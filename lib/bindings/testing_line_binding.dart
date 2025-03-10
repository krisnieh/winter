import 'package:get/get.dart';
import '../controllers/testing_line/testing_line_device_controller.dart';
import '../controllers/mqtt_controller.dart';

class TestingLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingLineDeviceController>(
      () => TestingLineDeviceController(),
      fenix: false,
    );
    
    // 设置测试线MQTT订阅
    final mqttController = Get.find<MqttController>();
    mqttController.setupTestingLineSubscriptions();
  }
} 