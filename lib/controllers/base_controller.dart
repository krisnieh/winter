import 'package:get/get.dart';
import 'package:dio/dio.dart';

class BaseController extends GetxController {
  final Dio _dio = Dio();

  Dio get dio => _dio;
}
