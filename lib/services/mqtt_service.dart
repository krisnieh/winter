import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class MqttService extends GetxService {
  static MqttService get instance => Get.find();
  late MqttServerClient _client;
  final RxBool isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initMqtt();
  }

  Future<void> _initMqtt() async {
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
      isConnected.value = true;
      if (kDebugMode) {
        print('MQTT连接成功');
      }
    } catch (e) {
      if (kDebugMode) {
        print('MQTT连接失败: $e');
      }
    }
  }

  void subscribe(String topic, Function(String) onMessage) {
    if (!isConnected.value) {
      if (kDebugMode) {
        print('MQTT未连接，无法订阅');
      }
      return;
    }

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
    if (isConnected.value) {
      _client.disconnect();
    }
    super.onClose();
  }
}
