import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../controllers/config_controller.dart';

class BaseController extends GetxController {
  final Dio _dio = Dio();
  final config = Get.find<ConfigController>();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    switch (config.line.value) {
      case 'WL':
        final list = config.parts.value[2].toUpperCase();
        final unit = config.parts.value[3];
        return '${config.serverUrl.value}/api/working_line/$list/$unit$endpoint';
      case 'TL':
        switch (config.type.value) {
          case 'unit':
            final unit = config.parts.value[3].toUpperCase();
            return '${config.serverUrl.value}/api/testing_line/unit/$unit$endpoint';
          case 'prepare':
            return '${config.serverUrl.value}/api/testing_line/prepare$endpoint';
        }
    }
    return '';
  }

  // 构建MQTT主题
  String buildMqttTopic(String endpoint) {
    switch (config.line.value) {
      case 'WL':
        final list = config.parts.value[2].toUpperCase();
        final unit = config.parts.value[3];
        return 'hsf/working_line/$list/$unit$endpoint';
      case 'TL':
        final type = config.parts[2];
        switch (type) {
          case 'unit':
            final unit = config.parts.value[3].toUpperCase();
            return 'hsf/testing_line/unit/$unit$endpoint';
          case 'prepare':
            return 'hsf/testing_line/prepare$endpoint';
        }
    }
    return '';
  }
}
