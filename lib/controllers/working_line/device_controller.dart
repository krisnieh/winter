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
  }

  Future<void> initLightStatus() async {
    try {
      final response = await dio.get(buildUrl('/lights/status'));
      isLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar(
        'Error',
        '获取灯光状态失败: ${e.toString()}',
        duration: const Duration(seconds: 20),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> setSliderValue() async {
    isSettingButtonEnabled.value = false;
    try {
      await dio.post(
        buildUrl('/settings'),
        data: {
          'value': sliderValue.value,
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSettingButtonEnabled.value = true;
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

  void setupMqttSubscription() {
    MqttService.instance.subscribe(
      buildMqttTopic('position'),
      (payload) {
        sliderValue.value = double.parse(payload);
      },
    );
  }
}
