import '../base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/mqtt_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TestingLineDeviceController extends BaseController {
  final RxDouble tlSliderValue = 0.0.obs;
  final RxBool isTLSettingButtonEnabled = true.obs;
  final RxBool isTLLightButtonEnabled = true.obs;
  final RxBool isTLLightOn = false.obs;
  final RxString tlRequestId = ''.obs;
  final RxString tlCallRequestId = ''.obs;
  final RxBool isTLCallButtonEnabled = true.obs;
  final RxString tlInputValue = ''.obs;
  // 水系统数据
  final RxDouble pollMm = 0.0.obs;
  final RxDouble pollNtu = 3.0.obs;
  final RxDouble unitMm = 0.0.obs;
  final RxDouble unitNtu = 0.0.obs;

  // 添加环境数据变量
  final RxDouble temperature = 0.0.obs;
  final RxDouble humidity = 0.0.obs;
  final RxInt lightLevel = 0.obs;

  bool _isCheckingLock = false;
  bool _isInitialized = false;  // 添加初始化标志
  bool _isAutoRecoveryScheduled = false;

  @override
  void onInit() {
    super.onInit();
    if (!_isInitialized) {
      _isInitialized = true;
      _initialize();
    }
  }

  Future<void> _initialize() async {
    print('开始初始化控制器...');
    try {
      // 按顺序执行初始化
      await initLightStatus();
      await initPosition();
      // setupPositionArrivedSubscription();
      setupCallArrivedSubscription();
      print('控制器初始化完成');
    } catch (e) {
      print('控制器初始化失败: $e');
    }
  }

  // void setupPositionArrivedSubscription() {
  //   final topic = buildMqttTopic('/arrived');
  //   print('[MQTT] 订阅位置到达主题: $topic');
    
  //   MqttService.instance.subscribe(topic).listen(
  //     (payload) {
  //       print('[MQTT] 收到位置到达消息: $payload');
  //       print('[MQTT] 当前请求ID: ${tlRequestId.value}');
        
  //       try {
  //         if (payload == tlRequestId.value) {
  //           print('[MQTT] ID匹配');
  //           tlRequestId.value = '';  // 只清除请求ID
            
  //           Get.snackbar(
  //             '提示',
  //             '位置设置完成',
  //             snackPosition: SnackPosition.TOP,
  //             duration: const Duration(seconds: 2),
  //           );
  //         } else {
  //           print('[MQTT] ID不匹配，忽略消息');
  //         }
  //       } catch (e, stack) {
  //         print('[MQTT] 处理消息时出错: $e');
  //         print('[MQTT] 错误堆栈: $stack');
  //       }
  //     },
  //     onError: (error) {
  //       print('[MQTT] 订阅错误: $error');
  //     },
  //   );
  // }

  void setupCallArrivedSubscription() {
    final topic = buildMqttTopic('/alert/deactived');
    
    Get.find<MqttService>().subscribe(topic).listen(
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
      print('获取灯光状态: $url');
      
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Request-Id': DateTime.now().millisecondsSinceEpoch.toString()},  // 添加请求ID
        ),
      );
      
      print('灯光状态响应: ${response.data}');
      isTLLightOn.value = response.data['status'] ?? false;
      
    } catch (e) {
      print('获取灯光状态失败: $e');
      Get.snackbar('Error', '获取灯光状态失败: ${e.toString()}');
    }
  }

  Future<void> initPosition() async {
    try {
      final url = buildUrl('/position');
      print('获取初始位置: $url');
      
      final response = await dio.get(url);
      print('初始位置响应: ${response.data}');
      
      if (response.data is Map<String, dynamic>) {
        final position = response.data['position'];
        if (position != null) {
          double value = double.parse(position.toString());
          // 确保初始值不小于2
          value = value < 2 ? 2 : value;
          tlSliderValue.value = value;
          print('设置初始位置成功: ${tlSliderValue.value}');
        }
      }
    } catch (e) {
      print('获取初始位置失败: $e');
      _handleInitPositionError(e);
    }
  }

  void _handleInitPositionError(dynamic error) {
    Get.snackbar(
      '提示',
      '获取初始位置失败，将使用默认值',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void setSliderValue(double value) {
    // 确保值不小于2
    if (value >= 2) {
      tlSliderValue.value = value;
    }
  }

  Future<void> toggleLight() async {
    isTLLightButtonEnabled.value = false;
    try {
      final response = await dio.get(buildUrl('/lights/toggle'));

      if (response.data is Map && response.data.containsKey('status')) {
        final bool status = response.data['status'] == true;
        isTLLightOn.value = status;
      } else {
        print('无效的灯光状态响应: ${response.data}');
      }
    } catch (e) {
      print('切换灯光失败: $e');
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
          print('呼叫操作超时: $currentRequestId');
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
    debugPrint('===== setPosition 开始 =====');  // 使用 debugPrint 替代 print
    
    try {
      // 1. 禁用按钮
      debugPrint('1. 禁用按钮');
      isTLSettingButtonEnabled.value = false;
      
      // 2. 发送请求
      final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      final url = buildUrl('/set_position/$value/$currentRequestId');
      debugPrint('2. 发送请求: $url');
      
      // 使用 Future.microtask 确保在主线程上执行
      Future.microtask(() async {
        try {
          await dio.get(url);
          debugPrint('3. 请求发送成功');
        } catch (e) {
          debugPrint('请求发送失败: $e');
        }
      });
      
      // 3. 等待1秒
      debugPrint('4. 开始等待1秒');
      await Future.delayed(const Duration(seconds: 1));
      
      // 4. 恢复按钮状态
      debugPrint('5. 恢复按钮状态');
      Get.back(); // 如果有对话框，关闭它
      isTLSettingButtonEnabled.value = true;
      
      debugPrint('===== setPosition 完成 =====');
      
    } catch (e) {
      debugPrint('setPosition 发生错误: $e');
      // 确保按钮状态恢复
      isTLSettingButtonEnabled.value = true;
    }
  }

  // 添加上行请求方法
  Future<void> sendUpRequest() async {
    try {
      final currentRequestId = DateTime.now().millisecondsSinceEpoch.toString();
      final url = buildUrl('/up/$currentRequestId');
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Request-Id': DateTime.now().millisecondsSinceEpoch.toString()},
        ),
      );
      
      if (response.statusCode == 200) {
        print('上行请求成功: $url');
      } else {
        throw '请求失败: ${response.statusCode}';
      }
    } catch (e) {
      print('上行请求失败: $e');
      Get.snackbar(
        '错误',
        '上行请求失败: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 