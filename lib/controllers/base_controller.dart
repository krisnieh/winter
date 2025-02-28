import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class BaseController extends GetxController {
  static const url = 'http://172.16.0.7:5000/api';

  final Dio _dio = Dio();
  late final List<String> parts;
  late final String map;

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _parseHostname();
  }

  void _parseHostname() {
    try {
      final hostname = Platform.localHostname; // 获取主机名
      parts = hostname.split('-');
      map = parts[1];
    } catch (e) {
      Get.snackbar('Error', '获取主机名失败: ${e.toString()}');
    }
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    switch (map) {
      case 'wl':
        final prefix = 'working_line';
        final line = parts[parts.length - 2].toUpperCase(); // 转为大写
        final unit = parts[parts.length - 1]; // 倒数第一个值
        return '$url/$prefix/$line/$unit$endpoint';
      case 'tl':
        final prefix = 'testing_line';
        final type = parts[2]; // 类型
        switch (type) {
          case 'unit':
            final unit = parts[parts.length - 1].toUpperCase(); // 倒数第一个值
            return '$url/$prefix/unit/$unit$endpoint';
          case 'prepare':
            return '$url/$prefix/prepare$endpoint';
          case 'lift':
            return '$url/$prefix/lift$endpoint';
          case 'belt':
            return '$url/$prefix/belt$endpoint';
        }
    }
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    switch (map) {
      case 'wl':
        final prefix = 'working_line';
        final line = parts[parts.length - 2].toUpperCase(); // 转为大写
        final unit = parts[parts.length - 1]; // 倒数第一个值
        return 'hsf/$prefix/$line/$unit${endpoint}';
      case 'tl':
        final prefix = 'testing_line';
        return 'hsf/$prefix/${endpoint}';
    }
  }
}
