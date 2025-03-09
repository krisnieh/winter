import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import './working_line/working_line_device_controller.dart';
import './testing_line/testing_line_device_controller.dart';
import './config_controller.dart';
import 'base_controller.dart';
import 'dart:convert';

class MqttController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    // 工作线位置到达
    final wlArrivedTopic = 'hsf/working_line/A/1/arrived';
    MqttService.instance.subscribe(wlArrivedTopic).listen(
      _handleWorkingLineArrived,
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    // 工作线呼叫响应
    final wlCallTopic = 'hsf/working_line/A/1/alert/deactived';
    MqttService.instance.subscribe(wlCallTopic).listen(
      _handleWorkingLineCall,
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    // 工作线环境数据订阅
    final wlEnvTopic = 'hsf/air/working_line';
    MqttService.instance.subscribe(wlEnvTopic).listen(
      (payload) => _handleEnvironmentData(payload, isWorkingLine: true),
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    // 检测线环境数据订阅
    final tlEnvTopic = 'hsf/air/testing_line';
    MqttService.instance.subscribe(tlEnvTopic).listen(
      (payload) => _handleEnvironmentData(payload, isWorkingLine: false),
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    final waterSystemTopic = 'hsf/polling/hub_1';
    MqttService.instance.subscribe(waterSystemTopic).listen(
      (payload) => _handleWaterSystemData(payload),
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    // 可以添加更多的订阅...
  }

  // 水系统数据
  void _handleWaterSystemData(String payload) {
    // print('水系统数据: $payload');
    try {
      final data = jsonDecode(payload);
      final controller = Get.find<TestingLineDeviceController>();
      final config = Get.find<ConfigController>();
      
      if (config.line.value == 'TL') {
        final unit = config.parts[3].toUpperCase();
        int mm_id = 0;
        int ntu_id = 0;
        
        // 根据单元确定要读取的数据ID
        switch (unit) {
          case 'A':
            mm_id = 1;
            ntu_id = 2;
            break;
          case 'B':
            mm_id = 3;
            ntu_id = 4;
            break;
          case 'C':
            mm_id = 5;
            ntu_id = 6;
            break;
          case 'D':
            mm_id = 7;
            ntu_id = 8;
            break;
          default:
            return;
        }
        
        // 转换单元数据
        if (data[mm_id.toString()] is List) {
          final List<dynamic> mmData = data[mm_id.toString()];
          if (mmData.length == 2) {
            final value = (mmData[0] << 8 | mmData[1]).toDouble();  // 合并两个8位数并除以10
            controller.unitMm.value = value;
            // print('单元${unit}水深: ${controller.unitMm.value}mm');
          }
        }
        
        if (data[ntu_id.toString()] is List) {
          final List<dynamic> ntuData = data[ntu_id.toString()];
          if (ntuData.length == 2) {
            final value = (ntuData[0] << 8 | ntuData[1])/100.0;  // 合并两个8位数并除以10
            controller.unitNtu.value = value;
            // print('单元${unit}浑浊度: ${controller.unitNtu.value}NTU');
          }
        }
      }
      
      // 转换水系统数据
      if (data['10'] is List) {
        final List<dynamic> pollMmData = data['10'];
        if (pollMmData.length == 2) {
          final value = (pollMmData[0] << 8 | pollMmData[1]).toDouble();
          controller.pollMm.value = value;
          // print('水系统水深: ${controller.pollMm.value}mm');
        }
      }
      
      if (data['9'] is List) {
        final List<dynamic> pollNtuData = data['9'];
        if (pollNtuData.length == 2) {
          final value = (pollNtuData[0] << 8 | pollNtuData[1])/100.0;
          controller.pollNtu.value = value;
          // print('水系统浑浊度: ${controller.pollNtu.value}NTU');
        }
      }
      
    } catch (e, stack) {
      print('处理水系统数据出错: $e');
      print('错误堆栈: $stack');
    }
  }

  void _handleWorkingLineArrived(String payload) {
    try {
      final controller = Get.find<WorkingLineDeviceController>();
      if (controller.wlRequestId.value.isEmpty) return;
      
      if (payload == controller.wlRequestId.value) {
        controller.wlRequestId.value = '';
        controller.isWLSettingButtonEnabled.value = true;
      }
    } catch (e) {
      print('处理工作线位置到达消息出错: $e');
    }
  }

  void _handleWorkingLineCall(String payload) {
    try {
      final controller = Get.find<WorkingLineDeviceController>();
      if (payload == controller.wlCallRequestId.value) {
        controller.isWLCallButtonEnabled.value = true;
        controller.wlCallRequestId.value = '';
      }
    } catch (e) {
      print('处理工作线呼叫响应消息出错: $e');
    }
  }

  void _handleEnvironmentData(String payload, {required bool isWorkingLine}) {
    try {
      final data = jsonDecode(payload);
      if (data['k0'] is List) {
        final List<dynamic> k0 = data['k0'];
        if (k0.length >= 6) {
          if (isWorkingLine) {
            final controller = Get.find<WorkingLineDeviceController>();
            _updateEnvironmentData(controller, k0);
          } else {
            final controller = Get.find<TestingLineDeviceController>();
            _updateEnvironmentData(controller, k0);
          }
        }
      }
    } catch (e, stack) {
      print('处理环境数据出错: $e');
      print('错误堆栈: $stack');
    }
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