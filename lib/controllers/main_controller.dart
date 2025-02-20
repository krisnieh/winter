import 'package:get/get.dart';
import 'package:dio/dio.dart';

class MainController extends GetxController {
  final Dio _dio = Dio();
  final RxString queryResult = ''.obs;
  final RxString inputValue = ''.obs;
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;

  void appendNumber(String number) {
    inputValue.value += number;
  }

  void deleteNumber() {
    if (inputValue.value.isNotEmpty) {
      inputValue.value =
          inputValue.value.substring(0, inputValue.value.length - 1);
    }
  }

  Future<void> query() async {
    try {
      final response = await _dio.get('/query', queryParameters: {
        'value': inputValue.value,
      });
      queryResult.value = response.data.toString();
    } catch (e) {
      queryResult.value = 'Error: $e';
    }
  }

  Future<void> setSliderValue() async {
    isSettingButtonEnabled.value = false;
    try {
      await _dio.post('/settings', data: {
        'value': sliderValue.value,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSettingButtonEnabled.value = true;
    }
  }
}
