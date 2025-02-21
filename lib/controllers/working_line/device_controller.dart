import '../base_controller.dart';
import 'package:get/get.dart';

class DeviceController extends BaseController {
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;
  final RxBool isLightButtonEnabled = true.obs;
  final RxBool isLightOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
  }

  Future<void> initLightStatus() async {
    try {
      final response = await dio.get('/light/status');
      isLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', '获取灯光状态失败: ${e.toString()}');
    }
  }

  Future<void> setSliderValue() async {
    isSettingButtonEnabled.value = false;
    try {
      await dio.post('/settings', data: {
        'value': sliderValue.value,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSettingButtonEnabled.value = true;
    }
  }

  Future<void> toggleLight() async {
    isLightButtonEnabled.value = false;
    try {
      final response = await dio.post('/light/toggle');
      isLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLightButtonEnabled.value = true;
    }
  }
}
