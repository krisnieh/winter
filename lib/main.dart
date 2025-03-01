import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/working_line/working_line_page.dart';
import 'services/mqtt_service.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'views/testing_line/testing_line_page.dart';
import 'dart:io';
import 'controllers/config_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  FullScreen.setFullScreen(true);
  
  // 初始化全局配置
  Get.put(ConfigController());
  Get.put(MqttService());

  // 获取主机名并决定初始路由
  final config = Get.find<ConfigController>();
  final String initialRoute = getInitialRoute(config);
  
  runApp(MyApp(initialRoute: initialRoute));
}

String getInitialRoute(ConfigController config) {
  if (config.line.value == 'TL') {
    switch (config.type.value) {
      case 'unit':
        return '/testing/unit';
      case 'prepare':
        return '/testing/prepare';
      case 'lift':
        return '/testing/lift';
      case 'belt':
        return '/testing/belt';
    }
  } else if (config.line.value == 'WL') {
    return '/working/unit';
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
      ],
      initialRoute: initialRoute,
    );
  }
}
