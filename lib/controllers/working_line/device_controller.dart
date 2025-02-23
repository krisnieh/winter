import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';

class DeviceController extends BaseController {
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;
  final RxBool isLightButtonEnabled = true.obs;
  final RxBool isLightOn = false.obs;
  final RxString requestId = ''.obs;

  // 添加一个变量来控制是否正在检测
  bool _isCheckingLock = false;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    initPosition();
    setupPositionArrivedSubscription();
  }

  void setupPositionArrivedSubscription() {
    final topic = buildMqttTopic('/arrived');
    print('topic: $topic');
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
    isSettingButtonEnabled.value = false;
    final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
    requestId.value = currentRequestId;

    // 添加30秒超时计时器
    Future.delayed(const Duration(seconds: 30), () {
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
}
