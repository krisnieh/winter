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
      if (!Get.isRegistered<ConfigController>()) {
        return;
      }

      final config = Get.find<ConfigController>();
      final controller = Get.find<TestingLineDeviceController>();

      try {
        final jsonData = jsonDecode(data);
        final unit = config.parts.value[3].toUpperCase();
        
        // 定义从站ID映射
        late int mm_id, ntu_id;
        const int pool_mm_id = 10;  // 水池液位从站ID固定为10

        // 根据单元选择对应的从站ID
        switch (unit) {
          case 'A':
            mm_id = 1;   // A单元液位
            ntu_id = 2;  // A单元浊度
            break;
          case 'B':
            mm_id = 2;   // B单元液位
            ntu_id = 4;  // B单元浊度
            break;
          case 'C':
            mm_id = 5;   // C单元液位
            ntu_id = 6;  // C单元浊度
            break;
          case 'D':
            mm_id = 7;   // D单元液位
            ntu_id = 8;  // D单元浊度
            break;
          default:
            print('未知单元: $unit');
            return;
        }

        // 解析数据
        // 单元液位 (mm)：直接将两个字节组合
        final unit_mm = (jsonData[mm_id.toString()][0] << 8 | jsonData[mm_id.toString()][1]) as int;
        
        // 单元浊度 (NTU)：直接将两个字节组合
        final unit_ntu = (jsonData[ntu_id.toString()][0] << 8 | jsonData[ntu_id.toString()][1]) as int;
        
        // 水池液位 (mm)：直接将两个字节组合
        final pool_mm = (jsonData[pool_mm_id.toString()][0] << 8 | jsonData[pool_mm_id.toString()][1]) as int;

        controller.unitMm.value = unit_mm.toDouble();
        controller.unitNtu.value = unit_ntu.toDouble()/100;
        controller.pollMm.value = pool_mm.toDouble();

        // 打印解析后的数据
        print('${unit}单元数据:');
        print('- 液位: $unit_mm mm');
        print('- 浊度: $unit_ntu NTU');
        print('水池液位: $pool_mm mm');

        // TODO: 更新控制器中的相关状态
        // controller.updateWaterSystemData(unit_mm, unit_ntu, pool_mm);

      } catch (e) {
        print('解析水系统数据失败: $e');
        print('原始数据: $data');
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
    
    // print('${controller.runtimeType} 环境数据更新: '
    //     '温度=${controller.temperature.value}°C, '
    //     '湿度=${controller.humidity.value}%, '
    //     '光照=${controller.lightLevel.value}lx');
  }
} 