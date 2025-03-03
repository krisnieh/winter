import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import './working_line/working_line_device_controller.dart';
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

    // 添加环境数据订阅
    final envTopic = 'hsf/air/working_line';
    MqttService.instance.subscribe(envTopic).listen(
      _handleEnvironmentData,
      onError: (error) => print('MQTT订阅错误: $error'),
    );

    // 可以添加更多的订阅...
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

  void _handleEnvironmentData(String payload) {
    try {
      final data = jsonDecode(payload);
      if (data['k0'] is List) {
        final List<dynamic> k0 = data['k0'];
        if (k0.length >= 6) {  // 确保有足够的数据
          final controller = Get.find<WorkingLineDeviceController>();
          
          // 将每两个值组合成一个16位整数
          // 温度: [18, 122] -> (18 << 8 | 122) = 4730
          final rawTemp = (k0[0] << 8 | k0[1]) as int;
          final temp = (rawTemp / 100) - 40;
          controller.temperature.value = double.parse(temp.toStringAsFixed(2));
          
          // 湿度: [26, 53] -> (26 << 8 | 53) = 6709
          final rawHumid = (k0[2] << 8 | k0[3]) as int;
          final humid = rawHumid / 100;
          controller.humidity.value = double.parse(humid.toStringAsFixed(2));
          
          // 光照: [0, 2] -> (0 << 8 | 2) = 2
          final rawLight = (k0[4] << 8 | k0[5]) as int;
          controller.lightLevel.value = rawLight;
          
          // print('环境数据更新: 温度=${controller.temperature.value}°C, 湿度=${controller.humidity.value}%, 光照=${controller.lightLevel.value}lx');s
        }
      }
    } catch (e, stack) {
      print('处理环境数据出错: $e');
      print('错误堆栈: $stack');
    }
  }
} 