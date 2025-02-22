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
      '172.16.0.8',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8083,
    );

    _client.useWebSocket = true;
    _client.port = 8083;
    _client.websocketProtocols = ['mqtt'];
    _client.server = 'ws://172.16.0.8';
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    try {
      await _client.connect();
      isConnected.value = true;
      if (kDebugMode) {
        print('MQTT连接成功');
      }
      // 连接成功后重新订阅
      _resubscribe();
    } catch (e) {
      if (kDebugMode) {
        print('MQTT连接失败: $e');
      }
      // 尝试重新连接
      Future.delayed(const Duration(seconds: 5), _initMqtt);
    }
  }

  void subscribe(String topic, Function(String) onMessage) {
    _subscriptions[topic] = onMessage; // 保存订阅信息

    if (isConnected.value) {
      _doSubscribe(topic, onMessage);
    } else {
      if (kDebugMode) {
        print('MQTT未连接，订阅将在连接后进行');
      }
    }
  }

  void _doSubscribe(String topic, Function(String) onMessage) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      onMessage(payload);
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
