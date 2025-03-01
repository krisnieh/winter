import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';
import 'package:dio/dio.dart';

class DeviceController extends BaseController {
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;
  final RxBool isLightButtonEnabled = true.obs;
  final RxBool isLightOn = false.obs;
  final RxString requestId = ''.obs;
  final RxString callRequestId = ''.obs;
  final RxBool isCallButtonEnabled = true.obs;
  final RxString inputValue = ''.obs;

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
        if (payload == requestId.value) {
          isSettingButtonEnabled.value = true;
          requestId.value = '';
        }
      },
    );
  }

  void setupCallArrivedSubscription() {
    MqttService.instance.subscribe(
      buildMqttTopic('/alert/deactived'),
      (payload) {
        if (payload == callRequestId.value) {
          isCallButtonEnabled.value = true;
          callRequestId.value = '';
        }
      },
    );
  }

  Future<void> initLightStatus() async {
    try {
      final response = await dio.get(buildUrl('/lights/status'));
      isLightOn.value = response.data['status'] ?? false;
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
          sliderValue.value = double.parse(position.toString());
        }
      }
    } catch (e) {
      Get.snackbar('Error', '获取初始位置失败: ${e.toString()}');
      print('获取初始位置失败: $e');
    }
  }

  Future<void> setSliderValue() async {
    if (!isSettingButtonEnabled.value) return;  // 如果当前有操作在进行，直接返回
    
    isSettingButtonEnabled.value = false;
    final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
    requestId.value = currentRequestId;

    // 添加30秒超时计时器
    Future.delayed(const Duration(seconds: 10), () {
      if (!isSettingButtonEnabled.value && requestId.value == currentRequestId) {
        isSettingButtonEnabled.value = true;
        requestId.value = '';
      }
    });

    try {
      final position = sliderValue.value.round();
      await dio.get(buildUrl('/set_position/$position/$currentRequestId'));
    } catch (e) {
      requestId.value = '';
      isSettingButtonEnabled.value = true;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> toggleLight() async {
    isLightButtonEnabled.value = false;
    try {
      final response = await dio.get(buildUrl('/lights/toggle'));

      if (response.data is Map && response.data.containsKey('status')) {
        final bool status = response.data['status'] == true;
        isLightOn.value = status;
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
      isLightButtonEnabled.value = true;
    }
  }

  Future<void> triggerCall() async {
    isCallButtonEnabled.value = false;
    final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
    callRequestId.value = currentRequestId;

    // 添加30秒超时计时器
    Future.delayed(const Duration(seconds: 30), () {
      if (!isCallButtonEnabled.value && callRequestId.value == currentRequestId) {
        isCallButtonEnabled.value = true;
        callRequestId.value = '';
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
      callRequestId.value = '';
      isCallButtonEnabled.value = true;
      Get.snackbar('Error', e.toString());
    }
  }

  void handleNumberPressed(String number) {
    if (inputValue.value.length < 11) {
      inputValue.value += number;
    }
  }

  void handleDelete() {
    if (inputValue.value.isNotEmpty) {
      inputValue.value = inputValue.value.substring(0, inputValue.value.length - 1);
    }
  }

  void handleSearch() {
    print('搜索: ${inputValue.value}');
  }
}
