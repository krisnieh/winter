import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class MqttService extends GetxService {
  static MqttService get instance => Get.find();
  late MqttServerClient _client;
  final RxBool isConnected = false.obs;
  final Map<String, Function(String)> _subscriptions = {}; // 存储订阅回调

  @override
  void onInit() {
    super.onInit();
    _initMqtt();
  }

  Future<void> _initMqtt() async {
    _client = MqttServerClient.withPort(
      'ws://172.16.0.8/mqtt',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8083,
    );

    _client.useWebSocket = true;
    _client.websocketProtocols = ['mqtt'];
    _client.secure = false;
    _client.port = 8083;
    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean();
    _client.keepAlivePeriod = 20;
    _client.logging(on: false); // 关闭日志

    try {
      await _client.connect();
      isConnected.value = true;
      // 连接成功后重新订阅
      _resubscribe();
    } catch (e) {
      // 尝试重新连接
      Future.delayed(const Duration(seconds: 5), _initMqtt);
    }
  }

  void subscribe(String topic, Function(String) onMessage) {
    _subscriptions[topic] = onMessage; // 保存订阅信息

    if (isConnected.value) {
      _doSubscribe(topic, onMessage);
    }
  }

  void _doSubscribe(String topic, Function(String) onMessage) {
    _client.subscribe(topic, MqttQos.atLeastOnce);

    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recTopic = c[0].topic;
      final message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      if (recTopic == topic) {
        onMessage(payload);
      }
    });
  }

  void _resubscribe() {
    for (var entry in _subscriptions.entries) {
      _doSubscribe(entry.key, entry.value);
    }
  }

  @override
  void onClose() {
    if (isConnected.value) {
      _client.disconnect();
    }
    _subscriptions.clear();
    super.onClose();
  }
}
