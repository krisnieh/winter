import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';
import 'package:dio/dio.dart';

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

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    initPosition();
    setupPositionArrivedSubscription();
    setupCallArrivedSubscription();
  }

  void setupPositionArrivedSubscription() {
    final topic = buildMqttTopic('/arrived');
    MqttService.instance.subscribe(
      topic,
      (payload) {
        if (payload == wlRequestId.value) {
          isWLSettingButtonEnabled.value = true;
          wlRequestId.value = '';
        }
      },
    );
  }

  void setupCallArrivedSubscription() {
    MqttService.instance.subscribe(
      buildMqttTopic('/alert/deactived'),
      (payload) {
        if (payload == wlCallRequestId.value) {
          isWLCallButtonEnabled.value = true;
          wlCallRequestId.value = '';
        }
      },
    );
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

      if (response.data is Map && response.data.containsKey('status')) {
        final bool status = response.data['status'] == true;
        isWLLightOn.value = status;
      } else {
        if (kDebugMode) {
          print('无效的灯光状态响应: ${response.data}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('切换灯光失败: $e');
      }
    } finally {
      isWLLightButtonEnabled.value = true;
    }
  }

  Future<void> triggerCall() async {
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
}
