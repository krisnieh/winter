import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;

// 将 MqttMessage 移到类外部
class MqttTopicMessage {
  final String topic;
  final String payload;
  MqttTopicMessage(this.topic, this.payload);
}

class MqttService extends GetxService {
  static MqttService get instance => Get.find();
  MqttServerClient? _client;  // 改为可空类型
  final RxBool isConnected = false.obs;
  
  // 存储待处理的订阅
  final Map<String, List<StreamController<String>>> _pendingSubscriptions = {};
  
  // 重连相关变量
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  
  @override
  void onInit() {
    super.onInit();
    _initMqtt();
  }

  Future<void> _initMqtt() async {
    // 如果已存在连接，先断开
    _client?.disconnect();

    _client = MqttServerClient.withPort(
      'ws://172.16.0.8/mqtt',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8083,
    );

    final client = _client;  // 局部变量保存引用
    if (client == null) return;  // 安全检查

    client.useWebSocket = true;
    client.websocketProtocols = ['mqtt'];
    client.secure = false;
    client.port = 8083;
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    // 设置自动重连
    client.autoReconnect = true;
    client.resubscribeOnAutoReconnect = false;

    client.onConnected = () {
      print('MQTT已连接');
      isConnected.value = true;
      _reconnectAttempts = 0;
      _cancelReconnectTimer();
      _setupMessageHandler();
      _resubscribeAll();
    };
    
    client.onDisconnected = () {
      print('MQTT已断开');
      isConnected.value = false;
      _startReconnectProcess();
    };

    client.onAutoReconnect = () {
      print('MQTT正在重连...');
    };

    client.onAutoReconnected = () {
      print('MQTT自动重连成功');
    };

    try {
      await client.connect();
    } catch (e) {
      print('MQTT连接失败: $e');
      _startReconnectProcess();
    }
  }

  void _setupMessageHandler() {
    final client = _client;
    if (client == null) return;

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
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
    final client = _client;
    if (client == null) return;

    print('重新订阅所有主题...');
    for (var topic in _pendingSubscriptions.keys) {
      print('重新订阅: $topic');
      client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  Stream<String> subscribe(String topic) {
    final controller = StreamController<String>.broadcast();
    _pendingSubscriptions.putIfAbsent(topic, () => []).add(controller);
    
    if (isConnected.value && _client != null) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
    }
    
    controller.onCancel = () {
      _pendingSubscriptions[topic]?.remove(controller);
      if (_pendingSubscriptions[topic]?.isEmpty ?? false) {
        _pendingSubscriptions.remove(topic);
        if (isConnected.value && _client != null) {
          _client!.unsubscribe(topic);
        }
      }
    };
    
    return controller.stream;
  }

  void _startReconnectProcess() {
    // 如果已经在重连，就不要重复启动
    if (_reconnectTimer?.isActive ?? false) return;

    // 重连间隔随着尝试次数增加而增加
    final reconnectDelay = Duration(seconds: math.min(30, 5 * (_reconnectAttempts + 1)));
    
    _reconnectTimer = Timer(reconnectDelay, () async {
      if (!isConnected.value && _reconnectAttempts < maxReconnectAttempts) {
        _reconnectAttempts++;
        print('MQTT重连尝试 $_reconnectAttempts/$maxReconnectAttempts');
        await _initMqtt();
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  void onClose() {
    _cancelReconnectTimer();
    for (var controllers in _pendingSubscriptions.values) {
      for (var controller in controllers) {
        controller.close();
      }
    }
    _pendingSubscriptions.clear();
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      _client?.disconnect();
    }
    _client = null;
    super.onClose();
  }
}
