import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../config_controller.dart';
import '../base_controller.dart';
import 'package:flutter/material.dart';

class TestingPrepareController extends GetxController {
  final inputValue = ''.obs;
  final searchResults = <String>[].obs;
  final isCallButtonEnabled = true.obs;
  final _dio = Dio();
  final _serverUrl = ConfigController.serverUrl;
  final _base = Get.put(BaseController());

  void onNumberPressed(String number) {
    inputValue.value += number;
  }

  void handleDelete() {
    if (inputValue.value.isNotEmpty) {
      inputValue.value = inputValue.value.substring(0, inputValue.value.length - 1);
    }
  }

  void onReturn() {
    // 处理回车事件，可以根据需要添加本地逻辑
    if (inputValue.value.isNotEmpty) {
      // 处理输入值
      inputValue.value = '';  // 清空输入
    }
  }

  Future<void> sendDownRequest(String unit) async {
    try {
      final requestId = '${unit}_${DateTime.now().millisecondsSinceEpoch}';

      final response = await _dio.get(
        _base.buildUrl('/down/$unit/$requestId'),
      );
      
      if (response.statusCode == 200) {
        Get.snackbar(
          '成功',
          '${unit}下行请求已发送',
          snackPosition: SnackPosition.TOP,
        );
        inputValue.value = '';  // 清空输入
      } else {
        throw '请求失败: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar(
        '错误',
        '下行请求失败: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 