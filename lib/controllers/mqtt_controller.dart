import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import '../controllers/working_line/working_line_device_controller.dart';
import '../controllers/testing_line/testing_line_device_controller.dart';
import './config_controller.dart';
import 'base_controller.dart';
import 'dart:convert';
import 'dart:async';
import '../controllers/admin/admin_controller.dart';

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
    unsubscribeAll();
    super.onClose();
  }

  void unsubscribeAll() {
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

  // 解析Modbus数据
  _paraseModbusData(List<dynamic> data) {
    if (data.length >= 2 && data[0] is int && data[1] is int) {
      final raw = (data[0] << 8 | data[1]) as int;
      return raw;
    }
    return 0;
  }

  void _handleWaterSystemData(String data) {
    try {
      final jsonData = jsonDecode(data);
      
      final map = <String, List<double>>{
        'A': [],
        'B': [],
        'C': [],
        'D': [],
        'poll': []
      };
      
      // 处理A单元数据
      if (jsonData['1'] != null) {
        final waterLevel = _paraseModbusData(jsonData['1']);
        map['A']?.add(waterLevel.toDouble());
      }
      if (jsonData['2'] != null) {
        final turbidity = _paraseModbusData(jsonData['2']);
        map['A']?.add(turbidity.toDouble());
      }
      
      // 处理B单元数据
      if (jsonData['3'] != null) {
        final waterLevel = _paraseModbusData(jsonData['3']);
        map['B']?.add(waterLevel.toDouble());
      }
      if (jsonData['4'] != null) {
        final turbidity = _paraseModbusData(jsonData['4']);
        map['B']?.add(turbidity.toDouble());
      }
      
      // 处理C单元数据
      if (jsonData['5'] != null) {
        final waterLevel = _paraseModbusData(jsonData['5']);
        map['C']?.add(waterLevel.toDouble());
      }
      if (jsonData['6'] != null) {
        final turbidity = _paraseModbusData(jsonData['6']);
        map['C']?.add(turbidity.toDouble());
      }
      
      // 处理D单元数据
      if (jsonData['7'] != null) {
        final waterLevel = _paraseModbusData(jsonData['7']);
        map['D']?.add(waterLevel.toDouble());
      }
      if (jsonData['8'] != null) {
        final turbidity = _paraseModbusData(jsonData['8']);
        map['D']?.add(turbidity.toDouble());
      }
      
      // 处理水池数据
      if (jsonData['10'] != null) {
        final waterLevel = _paraseModbusData(jsonData['10']);
        map['poll']?.add(waterLevel.toDouble());
      }

      // 如果AdminController已注册，更新其数据
      if (Get.isRegistered<AdminController>()) {
        Get.find<AdminController>().processWaterSystemData(map);
      } else {
        print('AdminController未注册');
      }
      
    } catch (e) {
      print('解析水系统数据失败: $e');
      print('原始数据: $data');
    }
  }

  // 工作线订阅
  void setupWorkingLineSubscriptions() {
    unsubscribeAll();
    
    _subscriptions['hsf/working_line/A/1/arrived'] = 
        _mqttService.subscribe('hsf/working_line/A/1/arrived').listen(_handleWorkingLineArrived);
    _subscriptions['hsf/air/working_line'] = 
        _mqttService.subscribe('hsf/air/working_line').listen(_handleEnvironmentData);
  }

  // 测试线订阅
  void setupTestingLineSubscriptions() {
    unsubscribeAll();
    
    _subscriptions['hsf/air/testing_line'] = 
        _mqttService.subscribe('hsf/air/testing_line').listen(_handleEnvironmentData);
    _subscriptions['hsf/polling/hub_1'] = 
        _mqttService.subscribe('hsf/polling/hub_1').listen(_handleWaterSystemData);
  }

  // 准备区订阅
  void setupTestingPrepareSubscriptions() {
    unsubscribeAll();
    // 如果准备区需要特定的MQTT主题，在这里添加
  }

  // 管理页面订阅
  void setupAdminSubscriptions() {
    unsubscribeAll();
    _subscriptions['hsf/polling/hub_1'] = 
        _mqttService.subscribe('hsf/polling/hub_1').listen(_handleWaterSystemData);
    print('已设置管理页面订阅');
  }

  void _updateEnvironmentData(dynamic controller, List<dynamic> k0) {
    // print('k0: $k0');
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
    
  }
} 