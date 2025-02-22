import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DeviceController extends BaseController {
  final RxDouble sliderValue = 0.0.obs;
  final RxBool isSettingButtonEnabled = true.obs;
  final RxBool isLightButtonEnabled = true.obs;
  final RxBool isLightOn = false.obs;
  late MqttServerClient _mqttClient;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    setupMqttClient();
  }

  @override
  void onClose() {
    _mqttClient.disconnect();
    super.onClose();
  }

  Future<void> initLightStatus() async {
    try {
      final response = await dio.get(buildUrl('/light/status'));
      isLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', '获取灯光状态失败: ${e.toString()}');
    }
  }

  Future<void> setSliderValue() async {
    isSettingButtonEnabled.value = false;
    try {
      await dio.post(
        buildUrl('/settings'),
        data: {
          'value': sliderValue.value,
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSettingButtonEnabled.value = true;
    }
  }

  Future<void> toggleLight() async {
    isLightButtonEnabled.value = false;
    try {
      final response = await dio.post(
        buildUrl('/light/toggle'),
        data: {},
      );
      isLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLightButtonEnabled.value = true;
    }
  }

  Future<void> setupMqttClient() async {
    _mqttClient = MqttServerClient.withPort(
      '172.16.0.8',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8083,
    );

    _mqttClient.useWebSocket = true;
    _mqttClient.port = 8083;
    _mqttClient.keepAlivePeriod = 20;
    _mqttClient.logging(on: false);

    try {
      await _mqttClient.connect();
      _mqttClient.subscribe(
        buildMqttTopic('position'),
        MqttQos.atLeastOnce,
      );

      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final message = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);

        sliderValue.value = double.parse(payload);
      });
    } catch (e) {
      Get.snackbar('Error', '连接MQTT服务器失败: ${e.toString()}');
    }
  }
}
