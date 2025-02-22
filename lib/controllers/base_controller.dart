import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class BaseController extends GetxController {
  final Dio _dio = Dio();
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
        line = parts[parts.length - 2].toUpperCase(); // 转为大写
        unit = parts[parts.length - 1]; // 倒数第一个值
      } else {
        line = 'UNKNOWN';
        unit = 'unknown';
      }
    } catch (e) {
      line = 'UNKNOWN';
      unit = 'unknown';
      Get.snackbar('Error', '获取主机名失败: ${e.toString()}');
    }
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    return 'http://172.16.0.8:5000/api/working_line/$line/$unit/$endpoint'
        .replaceAll('//', '/');
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    return 'hsf/working_line/$line/$unit/$endpoint';
  }
}
