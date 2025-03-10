import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/working_line/working_line_page.dart';
import 'services/mqtt_service.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'views/testing_line/testing_line_page.dart';
import 'views/testing_line/testing_prepare_page.dart';
import 'dart:io';
import 'controllers/config_controller.dart';
// import 'views/admin/admin_page.dart';
import 'controllers/working_line/working_line_device_controller.dart';
import 'controllers/testing_line/testing_line_device_controller.dart';
import 'controllers/testing_line/testing_prepare_controller.dart';
import 'controllers/mqtt_controller.dart';
import 'bindings/working_line_binding.dart';
import 'bindings/testing_line_binding.dart';
import 'bindings/testing_prepare_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  FullScreen.setFullScreen(true);
  
  // 只保留必要的全局控制器
  final configController = Get.put(ConfigController());
  
  try {
    await configController.initConfig();
    
    // 只保留全局必需的服务
    Get.put(MqttService());
    Get.put(MqttController());

    final config = Get.find<ConfigController>();
    final String initialRoute = getInitialRoute(config);
    
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
        GetPage(
          name: '/working/unit', 
          page: () => const WorkingLinePage(),
          binding: WorkingLineBinding(),
        ),
        GetPage(
          name: '/testing/unit', 
          page: () => const TestingLinePage(),
          binding: TestingLineBinding(),
        ),
        GetPage(
          name: '/testing/prepare', 
          page: () => const TestingPreparePage(),
          binding: TestingPrepareBinding(),
        ),
        // GetPage(name: '/admin', page: () => const AdminPage()),
      ],
      initialRoute: initialRoute,
    );
  }
}
