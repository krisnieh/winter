import 'package:get/get.dart';
import '../services/mqtt_service.dart';
import './working_line/working_line_device_controller.dart';

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
} 