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
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  
  final MqttServerClient _client;
  final Map<String, StreamController<String>> _streamControllers = {};
  final Map<String, Function(String)> _subscriptions = {};
  final RxBool isConnected = false.obs;
  
  // 存储待处理的订阅请求
  final Map<String, List<StreamController<String>>> _pendingSubscriptions = {};
  
  // 重连相关变量
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  
  MqttService._internal() : _client = MqttServerClient.withPort(
    'ws://172.16.0.8/mqtt',  // 添加 /mqtt 路径
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',  // 添加时间戳确保客户端ID唯一
    8083
  ) {
    _initMqtt();
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _initMqtt() async {
    // 如果已存在连接，先断开
    _client.disconnect();

    _client.useWebSocket = true;
    _client.websocketProtocols = ['mqtt'];
    _client.secure = false;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    // 设置自动重连
    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = false;

    _client.onConnected = () {
      print('MQTT已连接');
      isConnected.value = true;
      _reconnectAttempts = 0;
      _cancelReconnectTimer();
      _setupMessageHandler();
      _resubscribeAll();
    };
    
    _client.onDisconnected = () {
      print('MQTT已断开');
      isConnected.value = false;
      _startReconnectProcess();
    };

    _client.onAutoReconnect = () {
      print('MQTT正在重连...');
    };

    _client.onAutoReconnected = () {
      print('MQTT自动重连成功');
    };

    try {
      await _client.connect();
    } catch (e) {
      print('MQTT连接失败: $e');
      _startReconnectProcess();
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
    print('重新订阅所有主题...');
    for (var topic in _pendingSubscriptions.keys) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  Stream<String> subscribe(String topic) {
    final controller = StreamController<String>.broadcast();
    
    // 如果已连接，直接订阅
    if (isConnected.value) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      if (!_pendingSubscriptions.containsKey(topic)) {
        _pendingSubscriptions[topic] = [];
      }
      _pendingSubscriptions[topic]!.add(controller);
    } 
    // 如果未连接，将订阅请求加入待处理列表
    else {
      if (!_pendingSubscriptions.containsKey(topic)) {
        _pendingSubscriptions[topic] = [];
      }
      _pendingSubscriptions[topic]!.add(controller);
    }
    
    return controller.stream;
  }

  void unsubscribe(String topic) {
    _client.unsubscribe(topic);
    _streamControllers[topic]?.close();
    _streamControllers.remove(topic);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // 处理收到的消息
  void _handleMessage(String topic, String message) {
    _streamControllers[topic]?.add(message);
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
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.disconnect();
    }
    super.onClose();
  }
}

