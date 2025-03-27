import 'package:get/get.dart';
import '../base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mqtt_controller.dart';

class AdminController extends BaseController {
  // 通话按钮状态
  final RxBool isCallButtonEnabled = true.obs;
  
  // 传送带控制
  final RxInt southConveyorSpeed = 50.obs;
  final RxInt northConveyorSpeed = 50.obs;
  final RxString southConveyorDirection = 'UP'.obs;
  final RxString northConveyorDirection = 'UP'.obs;
  
  // 升降机控制
  final RxDouble liftHeight = 50.0.obs;
  
  // 检测单元A参数
  final RxInt unitAWaterLevel = 0.obs;
  final RxInt unitATurbidity = 0.obs;
  final RxBool isUnitAWaterInOn = false.obs;
  final RxBool isUnitAWaterOutOn = false.obs;
  final RxBool isUnitACleaningMode = false.obs;
  final RxBool isUnitAAutoWaterMode = false.obs;
  final RxBool isUnitABrakeReleased = false.obs;
  
  // 检测单元B参数
  final RxInt unitBWaterLevel = 0.obs;
  final RxInt unitBTurbidity = 0.obs;
  final RxBool isUnitBWaterInOn = false.obs;
  final RxBool isUnitBWaterOutOn = false.obs;
  final RxBool isUnitBCleaningMode = false.obs;
  final RxBool isUnitBAutoWaterMode = false.obs;
  final RxBool isUnitBBrakeReleased = false.obs;
  
  // 检测单元C参数
  final RxInt unitCWaterLevel = 0.obs;
  final RxInt unitCTurbidity = 0.obs;
  final RxBool isUnitCWaterInOn = false.obs;
  final RxBool isUnitCWaterOutOn = false.obs;
  final RxBool isUnitCCleaningMode = false.obs;
  final RxBool isUnitCAutoWaterMode = false.obs;
  final RxBool isUnitCBrakeReleased = false.obs;
  
  // 检测单元D参数
  final RxInt unitDWaterLevel = 0.obs;
  final RxInt unitDTurbidity = 0.obs;
  final RxBool isUnitDWaterInOn = false.obs;
  final RxBool isUnitDWaterOutOn = false.obs;
  final RxBool isUnitDCleaningMode = false.obs;
  final RxBool isUnitDAutoWaterMode = false.obs;
  final RxBool isUnitDBrakeReleased = false.obs;
  
  // 水池控制
  final RxInt poolWaterLevel = 0.obs;
  final RxBool isDrainPumpOn = false.obs;
  final RxBool isFillPumpOn = false.obs;
  final RxBool isWaterValveOn = false.obs;
  final RxBool isPoolAutoLevelControlOn = false.obs;

  final List<String> locations = ['NORTH', 'SOUTH'];
  final List<String> directions = ['UP', 'DOWN'];
  final List<String> speeds = ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100'];

  final TextEditingController liftHeightController = TextEditingController();

  final RxString liftHeightInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    liftHeightInput.value = '';
    // 初始化数据
    fetchInitialData();
    // 设置MQTT订阅
    if (Get.isRegistered<MqttController>()) {
      Get.find<MqttController>().setupAdminSubscriptions();
    }
  }

  // 处理通话功能
  void handleCall() {
    isCallButtonEnabled.value = false;
    // 这里可以添加实际的通话功能实现
    // 例如：启动语音通话、视频通话等
    
    // 模拟通话结束后重新启用按钮
    Future.delayed(const Duration(seconds: 5), () {
      isCallButtonEnabled.value = true;
    });
  }

  void fetchInitialData() async {
    try {
      // 这里应该从服务器获取初始数据
      // 模拟一些初始数据
      unitAWaterLevel.value = 120;
      unitATurbidity.value = 15;
      unitBWaterLevel.value = 150;
      unitBTurbidity.value = 20;
      unitCWaterLevel.value = 100;
      unitCTurbidity.value = 10;
      unitDWaterLevel.value = 130;
      unitDTurbidity.value = 25;
      poolWaterLevel.value = 500;
    } catch (e) {
      print('获取初始数据失败: $e');
    }
  }

  @override
  void onClose() {
    liftHeightController.dispose();
    // 取消MQTT订阅
    if (Get.isRegistered<MqttController>()) {
      Get.find<MqttController>().unsubscribeAll();
    }
    super.onClose();
  }

  // 传送带控制方法
  Future<void> startSouthConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/south/start';
      final params = {
        'speed': southConveyorSpeed.value,
        'direction': southConveyorDirection.value
      };
      
      await dio.post(url, data: params);
      Get.snackbar('成功', '南传送带启动成功');
    } catch (e) {
      Get.snackbar('错误', '南传送带启动失败: ${e.toString()}');
      print('南传送带启动失败: $e');
    }
  }

  Future<void> stopSouthConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/south/stop';
      await dio.get(url);
      Get.snackbar('成功', '南传送带停止成功');
    } catch (e) {
      Get.snackbar('错误', '南传送带停止失败: ${e.toString()}');
      print('南传送带停止失败: $e');
    }
  }
  
  Future<void> startNorthConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/north/start';
      final params = {
        'speed': northConveyorSpeed.value,
        'direction': northConveyorDirection.value
      };
      
      await dio.post(url, data: params);
      Get.snackbar('成功', '北传送带启动成功');
    } catch (e) {
      Get.snackbar('错误', '北传送带启动失败: ${e.toString()}');
      print('北传送带启动失败: $e');
    }
  }

  Future<void> stopNorthConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/north/stop';
      await dio.get(url);
      Get.snackbar('成功', '北传送带停止成功');
    } catch (e) {
      Get.snackbar('错误', '北传送带停止失败: ${e.toString()}');
      print('北传送带停止失败: $e');
    }
  }

  // 传送带控制方法 (保留以兼容旧代码)
  Future<void> startConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/start';
      final params = {
        'south_speed': southConveyorSpeed.value,
        'north_speed': northConveyorSpeed.value,
        'south_direction': southConveyorDirection.value,
        'north_direction': northConveyorDirection.value
      };
      
      await dio.post(url, data: params);
      Get.snackbar('成功', '传送带启动成功');
    } catch (e) {
      Get.snackbar('错误', '传送带启动失败: ${e.toString()}');
      print('传送带启动失败: $e');
    }
  }

  Future<void> stopConveyor() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/conveyor/stop';
      await dio.get(url);
      Get.snackbar('成功', '传送带停止成功');
    } catch (e) {
      Get.snackbar('错误', '传送带停止失败: ${e.toString()}');
      print('传送带停止失败: $e');
    }
  }

  // 升降机控制方法
  Future<void> startLift() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/lift/start';
      final params = {'height': liftHeight.value};
      
      await dio.post(url, data: params);
      Get.snackbar('成功', '升降机启动成功');
    } catch (e) {
      Get.snackbar('错误', '升降机启动失败: ${e.toString()}');
      print('升降机启动失败: $e');
    }
  }

  Future<void> emergencyStopLift() async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/lift/emergency_stop';
      await dio.get(url);
      Get.snackbar('成功', '升降机紧急停止成功');
    } catch (e) {
      Get.snackbar('错误', '升降机紧急停止失败: ${e.toString()}');
      print('升降机紧急停止失败: $e');
    }
  }

  // 检测单元控制方法
  Future<void> toggleUnitWaterSwitch(String unit, bool isWaterIn, bool value) async {
    try {
      final action = isWaterIn ? 'water_in' : 'water_out';
      final url = 'http://172.16.0.7:5000/api/hsf/admin/detection_unit/$unit/$action';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      
      // 更新本地状态
      if (isWaterIn) {
        switch(unit) {
          case 'A': isUnitAWaterInOn.value = value; break;
          case 'B': isUnitBWaterInOn.value = value; break;
          case 'C': isUnitCWaterInOn.value = value; break;
          case 'D': isUnitDWaterInOn.value = value; break;
        }
      } else {
        switch(unit) {
          case 'A': isUnitAWaterOutOn.value = value; break;
          case 'B': isUnitBWaterOutOn.value = value; break;
          case 'C': isUnitCWaterOutOn.value = value; break;
          case 'D': isUnitDWaterOutOn.value = value; break;
        }
      }
      
      final actionText = isWaterIn ? '进水' : '排水';
      final statusText = value ? '开启' : '关闭';
      Get.snackbar('成功', '单元 $unit $actionText$statusText成功');
    } catch (e) {
      Get.snackbar('错误', '切换开关失败: ${e.toString()}');
      print('切换开关失败: $e');
    }
  }
  
  // 检测单元清洁模式控制
  Future<void> toggleUnitCleaningMode(String unit, bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/detection_unit/$unit/cleaning_mode';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      
      // 更新本地状态
      switch(unit) {
        case 'A': isUnitACleaningMode.value = value; break;
        case 'B': isUnitBCleaningMode.value = value; break;
        case 'C': isUnitCCleaningMode.value = value; break;
        case 'D': isUnitDCleaningMode.value = value; break;
      }
      
      final statusText = value ? '开启' : '关闭';
      Get.snackbar('成功', '单元 $unit 清洁模式$statusText成功');
    } catch (e) {
      Get.snackbar('错误', '切换清洁模式失败: ${e.toString()}');
      print('切换清洁模式失败: $e');
    }
  }
  
  // 检测单元自动注水模式控制
  Future<void> toggleUnitAutoWaterMode(String unit, bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/detection_unit/$unit/auto_water';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      
      // 更新本地状态
      switch(unit) {
        case 'A': isUnitAAutoWaterMode.value = value; break;
        case 'B': isUnitBAutoWaterMode.value = value; break;
        case 'C': isUnitCAutoWaterMode.value = value; break;
        case 'D': isUnitDAutoWaterMode.value = value; break;
      }
      
      final statusText = value ? '开启' : '关闭';
      Get.snackbar('成功', '单元 $unit 自动注水模式$statusText成功');
    } catch (e) {
      Get.snackbar('错误', '切换自动注水模式失败: ${e.toString()}');
      print('切换自动注水模式失败: $e');
    }
  }

  // 检测单元刹车释放控制
  Future<void> toggleUnitBrakeRelease(String unit, bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/detection_unit/$unit/brake_release';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      
      // 更新本地状态
      switch(unit) {
        case 'A': isUnitABrakeReleased.value = value; break;
        case 'B': isUnitBBrakeReleased.value = value; break;
        case 'C': isUnitCBrakeReleased.value = value; break;
        case 'D': isUnitDBrakeReleased.value = value; break;
      }
      
      final statusText = value ? '释放' : '锁定';
      Get.snackbar('成功', '单元 $unit 刹车$statusText成功');
    } catch (e) {
      Get.snackbar('错误', '刹车控制失败: ${e.toString()}');
      print('刹车控制失败: $e');
    }
  }

  // 水池控制方法
  void updatePoolWaterLevel(int level) {
    poolWaterLevel.value = level;
  }
  
  // 更新检测单元的数据（来自MQTT或HTTP请求）
  void updateDetectionUnitData(Map<String, dynamic> data) {
    try {
      if (data.containsKey('A')) {
        final unitData = data['A'];
        unitAWaterLevel.value = unitData['water_level'] ?? unitAWaterLevel.value;
        unitATurbidity.value = unitData['turbidity'] ?? unitATurbidity.value;
      }
      
      if (data.containsKey('B')) {
        final unitData = data['B'];
        unitBWaterLevel.value = unitData['water_level'] ?? unitBWaterLevel.value;
        unitBTurbidity.value = unitData['turbidity'] ?? unitBTurbidity.value;
      }
      
      if (data.containsKey('C')) {
        final unitData = data['C'];
        unitCWaterLevel.value = unitData['water_level'] ?? unitCWaterLevel.value;
        unitCTurbidity.value = unitData['turbidity'] ?? unitCTurbidity.value;
      }
      
      if (data.containsKey('D')) {
        final unitData = data['D'];
        unitDWaterLevel.value = unitData['water_level'] ?? unitDWaterLevel.value;
        unitDTurbidity.value = unitData['turbidity'] ?? unitDTurbidity.value;
      }
      
      if (data.containsKey('pool')) {
        poolWaterLevel.value = data['pool']['water_level'] ?? poolWaterLevel.value;
      }
    } catch (e) {
      print('更新检测单元数据失败: $e');
    }
  }
  
  // 水池泵和阀门控制
  Future<void> toggleDrainPump(bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/pool/drain_pump';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      isDrainPumpOn.value = value;
      Get.snackbar('成功', '排水泵${value ? '开启' : '关闭'}成功');
    } catch (e) {
      Get.snackbar('错误', '排水泵控制失败: ${e.toString()}');
      print('排水泵控制失败: $e');
    }
  }
  
  Future<void> toggleFillPump(bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/pool/fill_pump';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      isFillPumpOn.value = value;
      Get.snackbar('成功', '注水泵${value ? '开启' : '关闭'}成功');
    } catch (e) {
      Get.snackbar('错误', '注水泵控制失败: ${e.toString()}');
      print('注水泵控制失败: $e');
    }
  }
  
  Future<void> toggleWaterValve(bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/pool/water_valve';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      isWaterValveOn.value = value;
      Get.snackbar('成功', '自来水开关${value ? '开启' : '关闭'}成功');
    } catch (e) {
      Get.snackbar('错误', '自来水开关控制失败: ${e.toString()}');
      print('自来水开关控制失败: $e');
    }
  }
  
  Future<void> togglePoolAutoLevelControl(bool value) async {
    try {
      final url = 'http://172.16.0.7:5000/api/hsf/admin/pool/auto_level_control';
      final params = {'value': value};
      
      await dio.post(url, data: params);
      isPoolAutoLevelControlOn.value = value;
      Get.snackbar('成功', '水池自动水位控制${value ? '开启' : '关闭'}成功');
    } catch (e) {
      Get.snackbar('错误', '水池自动水位控制失败: ${e.toString()}');
      print('水池自动水位控制失败: $e');
    }
  }
  
  // 解析水系统数据
  void processWaterSystemData(Map<String, List<double>> data) {
    try {
      // 处理A单元数据
      if (data['A'] != null && data['A']!.length >= 2) {
        unitAWaterLevel.value = data['A']![0].toInt();
        unitATurbidity.value = data['A']![1].toInt();
      }
      
      // 处理B单元数据
      if (data['B'] != null && data['B']!.length >= 2) {
        unitBWaterLevel.value = data['B']![0].toInt();
        unitBTurbidity.value = data['B']![1].toInt();
      }
      
      // 处理C单元数据
      if (data['C'] != null && data['C']!.length >= 2) {
        unitCWaterLevel.value = data['C']![0].toInt();
        unitCTurbidity.value = data['C']![1].toInt();
      }
      
      // 处理D单元数据
      if (data['D'] != null && data['D']!.length >= 2) {
        unitDWaterLevel.value = data['D']![0].toInt();
        unitDTurbidity.value = data['D']![1].toInt();
      }
      
      // 处理水池数据
      if (data['poll'] != null && data['poll']!.isNotEmpty) {
        poolWaterLevel.value = data['poll']![0].toInt();
      }
      
    } catch (e) {
      print('处理水系统数据失败: $e');
    }
  }

  // 解析Modbus数据
  int _paraseModbusData(List<dynamic> data) {
    if (data.length >= 2 && data[0] is int && data[1] is int) {
      final raw = (data[0] << 8 | data[1]) as int;
      return raw;
    }
    return 0;
  }
} 