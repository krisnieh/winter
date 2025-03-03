import 'package:get/get.dart';
import 'dart:io';

class ConfigController extends GetxController {
  static ConfigController get instance => Get.find();

  final RxString serverUrl = 'http://172.16.0.8:5006'.obs;
  final RxString hostname = ''.obs;
  final RxString line = ''.obs;      // WL 或 TL
  final RxString unit = ''.obs;      // 单元编号
  final RxString type = ''.obs;      // unit, prepare, lift, belt 等
  final RxList<String> parts = <String>[].obs;
  final RxString lineName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initConfig();
  }

  void initConfig() {
    try {
      hostname.value = Platform.localHostname;
      parts.value = hostname.value.split('-');
      line.value = parts.value[1].toUpperCase();
      lineName.value = getLineName();
    } catch (e) {
      print('初始化配置失败: $e');
    }
  }

  // 获取MQTT主题前缀
  String getLineName() {
    switch (line.value) {
      case 'TL':
        final unit = parts.value[3].toUpperCase();
        return 'TL - $unit';
      case 'WL':
        final list = parts.value[2].toUpperCase();
        final unit = parts.value[3];
        return '  WL - $list$unit';
      case 'AD':
        return '仓储';
      case 'QC':
        return '质检';
      case 'TASK':
        return '任务';
      case 'DASHBOARD':
        return '仪表盘';
      case 'ADMIN':
        final name = parts[2].toUpperCase();
        return '系统管理-$name';
      default:
        return 'working_line';
    }
  }
} 