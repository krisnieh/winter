import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class BaseController extends GetxController {
  final Dio _dio = Dio();
  late final String equipment;
  late final String line;
  late final String unit;

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _parseHostname();
  }

  void _parseHostname() {
    try {
      final hostname = Platform.localHostname; // 获取主机名
      final parts = hostname.split('_');
      if (parts.length == 3) {
        equipment = parts[0];
        line = parts[1];
        unit = parts[2];
      } else {
        equipment = 'unknown';
        line = 'unknown';
        unit = 'unknown';
      }
    } catch (e) {
      equipment = 'unknown';
      line = 'unknown';
      unit = 'unknown';
      Get.snackbar('Error', '获取主机名失败: ${e.toString()}');
    }
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    return '/api/$equipment/$line/$unit/$endpoint'.replaceAll('//', '/');
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    return 'hsf/working_line/$line/$unit/$endpoint';
  }
}
