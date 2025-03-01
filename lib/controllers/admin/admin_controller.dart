import 'package:get/get.dart';
import '../base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminController extends BaseController {
  final RxString selectedLocation = 'NORTH'.obs;
  final RxString selectedDirection = 'UP'.obs;
  final RxString selectedSpeed = '10'.obs;

  final List<String> locations = ['NORTH', 'SOUTH'];
  final List<String> directions = ['UP', 'DOWN'];
  final List<String> speeds = ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100'];

  final TextEditingController liftHeightController = TextEditingController();

  final RxString liftHeightInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    liftHeightInput.value = '';
  }

  @override
  void onClose() {
    liftHeightController.dispose();
    super.onClose();
  }

  Future<void> confirm() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/testing_line/belt/run'
          '/${selectedLocation.value}'
          '/${selectedDirection.value}'
          '/${selectedSpeed.value}';
          
      await dio.get(url);
      Get.snackbar('成功', '启动成功');
    } catch (e) {
      Get.snackbar('错误', '启动失败: ${e.toString()}');
      print('启动失败: $e');
    }
  }

  Future<void> stop() async {
    // 处理停止逻辑
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/testing_line/belt/stop'
          '/${selectedLocation.value}';

      await dio.get(url);
      Get.snackbar('成功', '停止成功');
    } catch (e) {
      Get.snackbar('错误', '停止失败: ${e.toString()}');
      print('停止失败: $e');
    }
  }

  Future<void> setLiftHeight() async {
    try {
      final height = double.parse(liftHeightController.text);
      if (height < 5 || height > 100) {
        Get.snackbar('错误', '高度必须在5到100之间');
        return;
      }

      final url = 'http://172.16.0.7:5000/api/hsf/admin/testing_line/lift/set_height/$height';
      await dio.get(url);
      Get.snackbar('成功', '设置成功');
    } catch (e) {
      Get.snackbar('错误', '设置失败: ${e.toString()}');
      print('设置失败: $e');
    }
  }
} 