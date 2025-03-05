import 'package:get/get.dart';
import 'package:dio/dio.dart';
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
      validateStatus: (status) => true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Connection': 'close',  // 强制不使用 keep-alive
      },
      followRedirects: true,
      maxRedirects: 5,
    ));

    // 添加日志拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('发起请求: ${options.uri}');
          print('请求头: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('收到响应: ${response.statusCode}');
          print('响应数据: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          print('请求错误:');
          print('- URL: ${error.requestOptions.uri}');
          print('- 类型: ${error.type}');
          print('- 消息: ${error.message}');
          
          // 超时自动重试
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            try {
              print('尝试重试请求...');
              final retryResponse = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: {
                    ...error.requestOptions.headers,
                    'Connection': 'close',
                  },
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              print('重试成功');
              return handler.resolve(retryResponse);
            } catch (e) {
              print('重试失败: $e');
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
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
