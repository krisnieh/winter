import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../controllers/config_controller.dart';

class BaseController extends GetxController {
  late final Dio _dio;
  final config = Get.find<ConfigController>();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ConfigController.serverUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status > 0; // 接受所有非空的状态码
      },
    ));

    // 添加响应拦截器以打印详细信息
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        print('API响应: ${response.requestOptions.uri}');
        print('状态码: ${response.statusCode}');
        print('响应数据: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('API错误: ${error.requestOptions.uri}');
        print('错误信息: ${error.message}');
        print('响应数据: ${error.response?.data}');
        return handler.next(error);
      },
    ));
  }

  // 构建完整的API URL
  String buildUrl(String endpoint) {
    switch (config.line.value) {
      case 'WL':
        final list = config.parts.value[2].toUpperCase();
        final unit = config.parts.value[3];
        return '${ConfigController.serverUrl}/api/working_line/$list/$unit$endpoint';
      case 'TL':
        final type = config.parts.value[2];
        switch (type) {
          case 'unit':
            final unit = config.parts.value[3].toUpperCase();
            return '${ConfigController.serverUrl}/api/testing_line/unit/$unit$endpoint';
          case 'prepare':
            return '${ConfigController.serverUrl}/api/testing_line/prepare$endpoint';
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
