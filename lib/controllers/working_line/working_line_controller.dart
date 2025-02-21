import '../base_controller.dart';
import 'package:get/get.dart';

class WorkingLineController extends BaseController {
  final RxString queryResult = ''.obs;
  final RxString inputValue = ''.obs;

  void appendNumber(String number) {
    if (inputValue.isEmpty && number == '0') return;
    if (inputValue.value.length >= 11) return;
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
      final response = await dio.get('/query', queryParameters: {
        'value': inputValue.value,
      });
      queryResult.value = response.data.toString();
    } catch (e) {
      queryResult.value = 'Error: $e';
    }
  }
}
