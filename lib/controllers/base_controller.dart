import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:hsf_app/controllers/config_controller.dart';

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
        return '$url/$prefix/${config.unit.value}$endpoint';
      case 'TL':
        switch (config.type.value) {
          case 'unit':
            return '$url/$prefix/unit/${config.unit.value}$endpoint';
          case 'prepare':
            return '$url/$prefix/prepare$endpoint';
          case 'lift':
            return '$url/$prefix/lift$endpoint';
          case 'belt':
            return '$url/$prefix/belt$endpoint';
        }
    }
    return '';
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    final prefix = config.getMqttPrefix();
    return '$prefix/${config.unit.value}$endpoint';
  }
}
