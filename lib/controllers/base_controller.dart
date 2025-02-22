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
      final parts = hostname.split('-');
      if (parts.length >= 2) {
        line = parts[parts.length - 2]; // 倒数第二个值
        unit = parts[parts.length - 1]; // 倒数第一个值
      } else {
        line = 'unknown';
        unit = 'unknown';
      }
    } catch (e) {
      line = 'unknown';
      unit = 'unknown';
      Get.snackbar('Error', '获取主机名失败: ${e.toString()}');
    }
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    equipment = 'working_line';

    return 'http://172.16.0.8:5000/api/$equipment/$line/$unit/$endpoint'
        .replaceAll('//', '/');
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    return 'hsf/working_line/$line/$unit/$endpoint';
  }
}
