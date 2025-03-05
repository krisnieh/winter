import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/working_line/working_line_page.dart';
import 'services/mqtt_service.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'views/testing_line/testing_line_page.dart';
import 'dart:io';
import 'controllers/config_controller.dart';
// import 'views/admin/admin_page.dart';
import 'controllers/working_line/working_line_device_controller.dart';
import 'controllers/testing_line/testing_line_device_controller.dart';
import 'controllers/mqtt_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  FullScreen.setFullScreen(true);
  
  // 初始化配置控制器
  final configController = Get.put(ConfigController());
  
  try {
    // 等待配置初始化完成
    await configController.initConfig();
    
    // 初始化其他服务
    Get.put(MqttService());
    Get.put(WorkingLineDeviceController());
    Get.put(TestingLineDeviceController());
    Get.put(MqttController());

    // 获取主机名并决定初始路由
    final config = Get.find<ConfigController>();
    final String initialRoute = getInitialRoute(config);
    
    // 启动应用
    runApp(MyApp(initialRoute: initialRoute));
  } catch (e) {
    // 显示错误界面
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            '配置初始化失败: $e\n请检查设备配置后重启应用',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

String getInitialRoute(ConfigController config) {
  if (config.line.value == 'TL') {
    final type = config.parts.value[2].toUpperCase();
    switch (type) {
      case 'UNIT':
        return '/testing/unit';
      case 'PREPARE':
        return '/testing/prepare';
      case 'LIFT':
        return '/testing/lift';
      case 'BELT':
        return '/testing/belt';
    }
  } else if (config.line.value == 'WL') {
    return '/working/unit';
  } else if (config.line.value == 'ADMIN') {
    return '/admin';
  }
  return '/working/unit';
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HenjouSmartFactory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/working/unit', page: () => const WorkingLinePage()),
        GetPage(name: '/testing/unit', page: () => const TestingLinePage()),
        // GetPage(name: '/admin', page: () => const AdminPage()),
      ],
      initialRoute: initialRoute,
    );
  }
}
