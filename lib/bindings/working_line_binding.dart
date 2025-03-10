import 'package:get/get.dart';
import '../controllers/working_line/working_line_device_controller.dart';
import '../controllers/mqtt_controller.dart';

class WorkingLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkingLineDeviceController>(
      () => WorkingLineDeviceController(),
      fenix: false, // 确保离开页面时释放资源
    );
    
    // 设置工作线MQTT订阅
    final mqttController = Get.find<MqttController>();
    mqttController.setupWorkingLineSubscriptions();
  }
} 