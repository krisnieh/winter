import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';

class MqttService extends GetxService {
  static MqttService get instance => Get.find();
  late MqttServerClient _client;

  Future<MqttService> init() async {
    _client = MqttServerClient.withPort(
      '172.16.0.8',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8083,
    );

    _client.useWebSocket = true;
    _client.port = 8083;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    try {
      await _client.connect();
    } catch (e) {
      Get.snackbar('Error', '连接MQTT服务器失败: ${e.toString()}');
    }

    return this;
  }

  void subscribe(String topic, Function(String) onMessage) {
    _client.subscribe(topic, MqttQos.atLeastOnce);

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      onMessage(payload);
    });
  }

  @override
  void onClose() {
    _client.disconnect();
    super.onClose();
  }
}
