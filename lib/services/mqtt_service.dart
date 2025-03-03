import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import 'dart:async';

// 将 MqttMessage 移到类外部
class MqttTopicMessage {
  final String topic;
  final String payload;
  MqttTopicMessage(this.topic, this.payload);
}

class MqttService extends GetxService {
  static MqttService get instance => Get.find();
  late MqttServerClient _client;
  final RxBool isConnected = false.obs;
  
  // 存储待处理的订阅
  final Map<String, List<StreamController<String>>> _pendingSubscriptions = {};
  
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
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    _client.onConnected = () {
      isConnected.value = true;
      _setupMessageHandler();
      _resubscribeAll();
    };
    
    _client.onDisconnected = () {
      isConnected.value = false;
      Future.delayed(const Duration(seconds: 5), _initMqtt);
    };

    try {
      await _client.connect();
    } catch (e) {
      Future.delayed(const Duration(seconds: 5), _initMqtt);
    }
  }

  void _setupMessageHandler() {
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final topic = c[0].topic;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      
      if (_pendingSubscriptions.containsKey(topic)) {
        for (var controller in _pendingSubscriptions[topic]!) {
          if (!controller.isClosed) {
            controller.add(payload);
          }
        }
      }
    });
  }

  void _resubscribeAll() {
    for (var topic in _pendingSubscriptions.keys) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  Stream<String> subscribe(String topic) {
    final controller = StreamController<String>.broadcast();
    _pendingSubscriptions.putIfAbsent(topic, () => []).add(controller);
    
    if (isConnected.value) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
    }
    
    controller.onCancel = () {
      _pendingSubscriptions[topic]?.remove(controller);
      if (_pendingSubscriptions[topic]?.isEmpty ?? false) {
        _pendingSubscriptions.remove(topic);
        if (isConnected.value) {
          _client.unsubscribe(topic);
        }
      }
    };
    
    return controller.stream;
  }

  @override
  void onClose() {
    for (var controllers in _pendingSubscriptions.values) {
      for (var controller in controllers) {
        controller.close();
      }
    }
    _pendingSubscriptions.clear();
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.disconnect();
    }
    super.onClose();
  }
}
