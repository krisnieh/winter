import 'package:get/get.dart';
import 'dart:io';

class ConfigController extends GetxController {
  static ConfigController get instance => Get.find();
  
  // 添加服务器URL配置
  static const String serverUrl = 'http://172.16.0.8:5006';
  
  final RxString hostname = ''.obs;
  final RxString line = ''.obs;      // WL 或 TL
  final RxString unit = ''.obs;      // 单元编号
  final RxString type = ''.obs;      // unit, prepare, lift, belt 等
  final RxList<String> parts = <String>[].obs;
  final RxString lineName = ''.obs;
  final RxMap<String, List<double>> waterSystemData = <String, List<double>>{}.obs;

  // 添加初始化状态标志
  final RxBool _isInitialized = false.obs;

  // 获取初始化状态
  bool get isInitialized => _isInitialized.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initConfig();
  }

  Future<void> initConfig() async {
    try {
      hostname.value = Platform.localHostname;
      if (hostname.value.isEmpty) {
        throw Exception('获取主机名失败');
      }

      parts.value = hostname.value.split('-');
      if (parts.isEmpty) {
        throw Exception('主机名格式错误: ${hostname.value}');
      }

      line.value = parts.value[1].toUpperCase();
      if (line.value.isEmpty) {
        throw Exception('获取生产线类型失败');
      }

      lineName.value = getLineName();
      if (lineName.value.isEmpty) {
        throw Exception('获取生产线名称失败');
      }

      _isInitialized.value = true;
      print('配置初始化成功: ${hostname.value}');
    } catch (e) {
      print('配置初始化失败: $e');
      _isInitialized.value = false;
      rethrow; // 重新抛出异常，让上层知道初始化失败
    }
  }

  String getPrepareLineName() {
    if (line.value == 'TL' && parts.value[2].toUpperCase() == 'PREPARE') {
      final unit = parts.value[3].toUpperCase();
      return unit;
    }
    return '';
  }

  // 获取MQTT主题前缀
  String getLineName() {
    switch (line.value) {
      case 'TL':
        final type = parts.value[2].toUpperCase();
        switch (type) {
          case 'UNIT':
            final unit = parts.value[3].toUpperCase();
            return 'TL - $unit';
          case 'PREPARE':
            final unit = parts.value[3].toUpperCase();
            return 'TL - P-$unit';
          default:
            return 'TL - $type';
        }
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