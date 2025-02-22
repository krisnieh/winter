import '../base_controller.dart';
import 'package:get/get.dart';
import '../../services/mqtt_service.dart';
import 'package:flutter/foundation.dart';

class DeviceController extends BaseController {
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;
  final RxBool isLightButtonEnabled = true.obs;
  final RxBool isLightOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    setupMqttSubscription();
    setupSettingSubscription();
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

  void setupMqttSubscription() {
    MqttService.instance.subscribe(
      buildMqttTopic('position'),
      (payload) {
        print('position: $payload');
        sliderValue.value = double.parse(payload);
      },
    );
  }

  void setupSettingSubscription() {
    MqttService.instance.subscribe(
      buildMqttTopic('go_finished'),
      (payload) {
        print('go_finished: $payload');
        isSettingButtonEnabled.value = payload == "done";
      },
    );
  }

  Future<void> setSliderValue() async {
    isSettingButtonEnabled.value = false;

    // 添加30秒超时计时器
    Future.delayed(const Duration(seconds: 30), () {
      if (!isSettingButtonEnabled.value) {
        isSettingButtonEnabled.value = true;
        if (kDebugMode) {
          print('设置位置操作超时');
        }
      }
    });

    try {
      await dio.get(
        buildUrl('/set_position/${sliderValue.value}'),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('设置位置失败: $e');
    }
  }

  Future<void> toggleLight() async {
    isLightButtonEnabled.value = false;
    try {
      final response = await dio.get(
        buildUrl('/lights/toggle'),
      );

      // 验证响应数据格式
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
