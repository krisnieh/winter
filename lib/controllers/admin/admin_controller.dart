import 'package:get/get.dart';

class AdminController extends GetxController {
  final RxString selectedLine = 'WL'.obs;
  final RxString selectedType = 'unit'.obs;
  final RxString selectedUnit = 'U1'.obs;

  final List<String> lines = ['WL', 'TL'];
  final List<String> types = ['unit', 'prepare', 'lift', 'belt'];
  final List<String> units = ['U1', 'U2', 'U3', 'U4', 'U5'];

  void confirm() {
    // 处理确认逻辑
    print('选择的配置: ${selectedLine.value}-${selectedType.value}-${selectedUnit.value}');
  }
} 