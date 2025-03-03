import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WorkingLineDeviceController extends BaseController {
  final RxDouble wlSliderValue = 0.0.obs;
  final RxBool isWLSettingButtonEnabled = true.obs;
  final RxBool isWLLightButtonEnabled = true.obs;
  final RxBool isWLLightOn = false.obs;
  final RxString wlRequestId = ''.obs;
  final RxString wlCallRequestId = ''.obs;
  final RxBool isWLCallButtonEnabled = true.obs;
  final RxString wlInputValue = ''.obs;

  // 添加一个变量来控制是否正在检测
  bool _isCheckingLock = false;

  // 添加 disposed 变量
  final RxBool _disposed = false.obs;

  // 添加环境数据状态
  final RxDouble temperature = 0.0.obs;
  final RxDouble humidity = 0.0.obs;
  final RxInt lightLevel = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    initPosition();
  }

  Future<void> initLightStatus() async {
    try {
      final response = await dio.get(buildUrl('/lights/status'));
      isWLLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', '获取灯光状态失败: ${e.toString()}');
      print('获取灯光状态失败: ${e.toString()}');
    }
  }

  Future<void> initPosition() async {
    try {
      final response = await dio.get(buildUrl('/position'));
      if (response.data is Map<String, dynamic>) {
        final position = response.data['position'];
        if (position != null) {
          wlSliderValue.value = double.parse(position.toString());
        }
      }
    } catch (e) {
      Get.snackbar('Error', '获取初始位置失败: ${e.toString()}');
      print('获取初始位置失败: $e');
    }
  }

  void setSliderValue(double value) {
    wlSliderValue.value = value;
  }

  Future<void> toggleLight() async {
    isWLLightButtonEnabled.value = false;
    try {
      final response = await dio.get(buildUrl('/lights/toggle'));
      isWLLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', '切换灯光失败: ${e.toString()}');
      print('切换灯光失败: ${e.toString()}');
    } finally {
      isWLLightButtonEnabled.value = true;
    }
  }


  Future<void> triggerCall() async {
    // 首先显示确认对话框
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          '呼叫质检支持',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '所有呼叫将会被记录，并用于工作评估，请确认是否发起？',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '取消',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    // 只有在用户确认后才执行呼叫
    if (result == true) {
      isWLCallButtonEnabled.value = false;
      final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      wlCallRequestId.value = currentRequestId;

      Future.delayed(const Duration(seconds: 30), () {
        if (!isWLCallButtonEnabled.value && wlCallRequestId.value == currentRequestId) {
          isWLCallButtonEnabled.value = true;
          wlCallRequestId.value = '';
          if (kDebugMode) {
            print('呼叫操作超时: $currentRequestId');
          }
        }
      });

      try {
        final url = buildUrl('/alert/active/$currentRequestId');
        await dio.get(
          url,
          options: Options(
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
      } catch (e) {
        wlCallRequestId.value = '';
        isWLCallButtonEnabled.value = true;
        Get.snackbar('Error', e.toString());
      }
    }
  }

  void handleNumberPressed(String number) {
    if (wlInputValue.value.length < 11) {
      wlInputValue.value += number;
    }
  }

  void handleDelete() {
    if (wlInputValue.value.isNotEmpty) {
      wlInputValue.value = wlInputValue.value.substring(0, wlInputValue.value.length - 1);
    }
  }

  void handleSearch() {
    print('搜索: ${wlInputValue.value}');
  }

  Future<void> setPosition(String value) async {
    final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
    
    wlRequestId.value = currentRequestId;
    isWLSettingButtonEnabled.value = false;
    
    Future.delayed(const Duration(seconds: 10), () {
      if (wlRequestId.value == currentRequestId) {
        wlRequestId.value = '';
        isWLSettingButtonEnabled.value = true;
        
        Get.snackbar(
          '提示',
          '位置设置超时',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    });
    
    try {
      final url = buildUrl('/set_position/$value/$currentRequestId');
      await dio.get(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
    } catch (e) {
      wlRequestId.value = '';
      isWLSettingButtonEnabled.value = true;
      throw e;
    }
  }

  @override
  void onClose() {
    _disposed.value = true;
    super.onClose();
  }
}
