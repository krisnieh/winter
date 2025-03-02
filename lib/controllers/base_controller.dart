import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../controllers/config_controller.dart';

class BaseController extends GetxController {
  static const url = 'http://172.16.0.7:5000/api';

  final Dio _dio = Dio();
  final config = Get.find<ConfigController>();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    final prefix = config.getApiPrefix();
    switch (config.line.value) {
      case 'WL':
        final list = config.parts.value[2].toUpperCase();
        final unit = config.parts.value[3];
        return '$url/working_line/$list/$unit$endpoint';
      case 'TL':
        switch (config.type.value) {
          case 'unit':
            final unit = config.parts.value[3].toUpperCase();
            return '$url/testing_line/unit/$unit$endpoint';
          case 'prepare':
            return '$url/testing_line/prepare$endpoint';
        }
    }
    return '';
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    final prefix = config.getMqttPrefix();
    switch (config.line.value) {
      case 'WL':
        final list = config.parts.value[2].toUpperCase();
        final unit = config.parts.value[3];
        return '$prefix/$list/$unit$endpoint';
      case 'TL':
        final unit = config.parts.value[3].toUpperCase();
        return '$prefix/unit/$unit$endpoint';
    }
    return '';
  }
}
