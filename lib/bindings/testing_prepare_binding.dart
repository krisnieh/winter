import 'package:get/get.dart';
import '../controllers/testing_line/testing_prepare_controller.dart';
import '../controllers/mqtt_controller.dart';

class TestingPrepareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestingPrepareController>(
      () => TestingPrepareController(),
      fenix: false,
    );
    
    // 设置准备区MQTT订阅
    final mqttController = Get.find<MqttController>();
    mqttController.setupTestingPrepareSubscriptions();
  }
} 