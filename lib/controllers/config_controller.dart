import 'package:get/get.dart';
import 'dart:io';

class ConfigController extends GetxController {
  static ConfigController get instance => Get.find();

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
      line.value = parts[1].toUpperCase();
      lineName.value = getLineName();
    } catch (e) {
      print('初始化配置失败: $e');
    }
  }

  // 获取MQTT主题前缀
  String getLineName() {
    switch (line.value) {
      case 'TL':
        return 'testing_line';
      case 'WL':
        return 'working_line';
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

  // 获取MQTT主题前缀
  String getMqttPrefix() {
    switch (line.value) {
      case 'TL':
        return 'hsf/testing_line';
      case 'WL':
        return 'hsf/working_line';
      case 'QC':
        return 'hsf/qc';
      case 'TASK':
        return 'hsf/task';
      case 'DASHBOARD':
        return 'hsf/dashboard';
      case 'ADMIN':
        return 'hsf/admin';
      default:
        return 'hsf';
    }
  }

  // 获取API前缀
  String getApiPrefix() {
    switch (line.value) {
      case 'TL':
        return 'testing_line';
      case 'WL':
        return 'working_line';
      case 'QC':
        return 'qc';
      case 'TASK':
        return 'task';
      case 'DASHBOARD':
        return 'dashboard';
      case 'ADMIN':
        return 'admin';
      default:
        return '';
    }
  }
} 