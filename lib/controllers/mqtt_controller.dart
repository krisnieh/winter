import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import '../controllers/working_line/working_line_device_controller.dart';
import '../controllers/testing_line/testing_line_device_controller.dart';
import './config_controller.dart';
import 'base_controller.dart';
import 'dart:convert';
import 'dart:async';

class MqttController extends GetxController {
  final MqttService _mqttService = Get.find<MqttService>();
  final Map<String, StreamSubscription<String>> _subscriptions = {};

  @override
  void onInit() {
    super.onInit();
    print('MQTT控制器初始化');
  }

  @override
  void onClose() {
    _unsubscribeAll();
    super.onClose();
  }

  void _unsubscribeAll() {
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void _handleWorkingLineArrived(String data) {
    try {
      final controller = Get.find<WorkingLineDeviceController>();
      if (controller.wlRequestId.value.isEmpty) return;
      
      if (data == controller.wlRequestId.value) {
        controller.wlRequestId.value = '';
        controller.isWLSettingButtonEnabled.value = true;
      }
    } catch (e, stack) {
      print('处理工作线位置到达消息出错: $e');
      if (e.toString().contains('not found')) return;
      print('错误堆栈: $stack');
    }
  }

  void _handleEnvironmentData(String data) {
    try {
      if (Get.isRegistered<WorkingLineDeviceController>()) {
        final controller = Get.find<WorkingLineDeviceController>();
        _updateEnvironmentData(controller, jsonDecode(data)['k0']);
      }
      if (Get.isRegistered<TestingLineDeviceController>()) {
        final controller = Get.find<TestingLineDeviceController>();
        _updateEnvironmentData(controller, jsonDecode(data)['k0']);
      }
    } catch (e, stack) {
      print('处理环境数据出错: $e');
      print('错误堆栈: $stack');
    }
  }

  void _handleWaterSystemData(String data) {
    try {
      if (!Get.isRegistered<TestingLineDeviceController>()) {
        return;  // 如果控制器未注册，直接返回
      }

      final controller = Get.find<TestingLineDeviceController>();
      // 处理数据
      try {
        final jsonData = jsonDecode(data);
        // 处理数据逻辑
        // ...
      } catch (e) {
        print('解析水系统数据失败: $e');
      }
    } catch (e, stack) {
      print('处理水系统数据出错: $e');
      print('错误堆栈: $stack');
    }
  }

  // 工作线订阅
  void setupWorkingLineSubscriptions() {
    _unsubscribeAll();
    
    _subscriptions['hsf/working_line/A/1/arrived'] = 
        _mqttService.subscribe('hsf/working_line/A/1/arrived').listen(_handleWorkingLineArrived);
    _subscriptions['hsf/air/working_line'] = 
        _mqttService.subscribe('hsf/air/working_line').listen(_handleEnvironmentData);
  }

  // 测试线订阅
  void setupTestingLineSubscriptions() {
    _unsubscribeAll();
    
    _subscriptions['hsf/air/testing_line'] = 
        _mqttService.subscribe('hsf/air/testing_line').listen(_handleEnvironmentData);
    _subscriptions['hsf/polling/hub_1'] = 
        _mqttService.subscribe('hsf/polling/hub_1').listen(_handleWaterSystemData);
  }

  // 准备区订阅
  void setupTestingPrepareSubscriptions() {
    _unsubscribeAll();
    // 如果准备区需要特定的MQTT主题，在这里添加
  }

  void _updateEnvironmentData(dynamic controller, List<dynamic> k0) {
    // 温度
    final rawTemp = (k0[0] << 8 | k0[1]) as int;
    final temp = (rawTemp / 100) - 40;
    controller.temperature.value = double.parse(temp.toStringAsFixed(2));
    
    // 湿度
    final rawHumid = (k0[2] << 8 | k0[3]) as int;
    final humid = rawHumid / 100;
    controller.humidity.value = double.parse(humid.toStringAsFixed(2));
    
    // 光照
    final rawLight = (k0[4] << 8 | k0[5]) as int;
    controller.lightLevel.value = rawLight;
    
    // print('${controller.runtimeType} 环境数据更新: '
    //     '温度=${controller.temperature.value}°C, '
    //     '湿度=${controller.humidity.value}%, '
    //     '光照=${controller.lightLevel.value}lx');
  }
} 