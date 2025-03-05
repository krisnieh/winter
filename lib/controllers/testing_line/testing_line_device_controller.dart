import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TestingLineDeviceController extends BaseController {
  final RxDouble tlSliderValue = 0.0.obs;
  final RxBool isTLSettingButtonEnabled = true.obs;
  final RxBool isTLLightButtonEnabled = true.obs;
  final RxBool isTLLightOn = false.obs;
  final RxString tlRequestId = ''.obs;
  final RxString tlCallRequestId = ''.obs;
  final RxBool isTLCallButtonEnabled = true.obs;
  final RxString tlInputValue = ''.obs;

  bool _isCheckingLock = false;

  @override
  void onInit() {
    super.onInit();
    initLightStatus();
    initPosition();
    setupPositionArrivedSubscription();
    setupCallArrivedSubscription();
  }

  void setupPositionArrivedSubscription() {
    final topic = buildMqttTopic('/arrived');
    print('[Controller] 订阅位置到达主题: $topic');
    
    MqttService.instance.subscribe(topic).listen(
      (payload) {
        print('[Controller] 收到MQTT消息: $payload');
        
        try {
          final payloadStr = payload.trim();
          final requestStr = tlRequestId.value.trim();
          
          print('[Controller] 比较ID: payload=$payloadStr, requestId=$requestStr');
          
          if (payloadStr == requestStr) {
            print('[Controller] ID匹配，更新状态');
            isTLSettingButtonEnabled.value = true;
            tlRequestId.value = '';
            
            Get.snackbar(
              '提示',
              '位置设置完成',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
          }
        } catch (e, stack) {
          print('[Controller] 处理消息时出错: $e');
          print('[Controller] 错误堆栈: $stack');
        }
      },
      onError: (error) {
        print('[Controller] MQTT订阅错误: $error');
      },
    );
  }

  void setupCallArrivedSubscription() {
    final topic = buildMqttTopic('/alert/deactived');
    
    MqttService.instance.subscribe(topic).listen(
      (payload) {
        if (payload == tlCallRequestId.value) {
          isTLCallButtonEnabled.value = true;
          tlCallRequestId.value = '';
        }
      },
      onError: (error) {
        print('[Controller] MQTT订阅错误: $error');
      },
    );
  }

  Future<void> initLightStatus() async {
    try {
      final url = buildUrl('/lights/status');
      print('获取灯光状态请求: $url');
      final response = await dio.get(url);
      isTLLightOn.value = response.data['status'] ?? false;
    } catch (e) {
      Get.snackbar('Error', '获取灯光状态失败: ${e.toString()}');
      print('获取灯光状态失败: ${e.toString()}');
    }
  }

  Future<void> initPosition() async {
    try {
      final url = buildUrl('/position');
      print('获取初始位置请求: $url');
      final response = await dio.get(url);
      if (response.data is Map<String, dynamic>) {
        final position = response.data['position'];
        if (position != null) {
          tlSliderValue.value = double.parse(position.toString());
        }
      }
    } catch (e) {
      Get.snackbar('Error', '获取初始位置失败: ${e.toString()}');
      print('获取初始位置失败: $e');
    }
  }

  void setSliderValue(double value) {
    tlSliderValue.value = value;
  }

  Future<void> toggleLight() async {
    isTLLightButtonEnabled.value = false;
    try {
      final response = await dio.get(buildUrl('/lights/toggle'));

      if (response.data is Map && response.data.containsKey('status')) {
        final bool status = response.data['status'] == true;
        isTLLightOn.value = status;
      } else {
        if (kDebugMode) {
          print('无效的灯光状态响应: ${response.data}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('切换灯光失败: $e');
      }
    } finally {
      isTLLightButtonEnabled.value = true;
    }
  }

  Future<void> triggerCall() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          '呼叫质检支持',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '所有呼叫将会被记录，并用于工作评估，请确认是否发起？',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '取消',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    if (result == true) {
      isTLCallButtonEnabled.value = false;
      final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      tlCallRequestId.value = currentRequestId;

      Future.delayed(const Duration(seconds: 30), () {
        if (!isTLCallButtonEnabled.value && tlCallRequestId.value == currentRequestId) {
          isTLCallButtonEnabled.value = true;
          tlCallRequestId.value = '';
          if (kDebugMode) {
            print('呼叫操作超时: $currentRequestId');
          }
        }
      });

      try {
        final url = buildUrl('/alert/active/$currentRequestId');
        await dio.get(
          url,
          options: Options(
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
      } catch (e) {
        tlCallRequestId.value = '';
        isTLCallButtonEnabled.value = true;
        Get.snackbar('Error', e.toString());
      }
    }
  }

  void handleNumberPressed(String number) {
    if (tlInputValue.value.length < 11) {
      tlInputValue.value += number;
    }
  }

  void handleDelete() {
    if (tlInputValue.value.isNotEmpty) {
      tlInputValue.value = tlInputValue.value.substring(0, tlInputValue.value.length - 1);
    }
  }

  void handleSearch() {
    print('搜索: ${tlInputValue.value}');
  }

  Future<void> setPosition(String value) async {
    final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
    tlRequestId.value = currentRequestId;
    
    try {
      final url = buildUrl('/set_position/$value/$currentRequestId');
      print('设置位置请求: $url');
      await dio.get(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
    } catch (e) {
      tlRequestId.value = '';
      isTLSettingButtonEnabled.value = true;
      throw e;
    }
  }
} 