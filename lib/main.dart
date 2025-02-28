import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/working_line/working_line_page.dart';
import 'services/mqtt_service.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'views/testing_line/testing_line_page.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  FullScreen.setFullScreen(true);
  Get.put(MqttService());

  // 获取主机名并决定初始路由
  final String hostname = Platform.localHostname;
  final String initialRoute = getInitialRoute(hostname);
  
  runApp(MyApp(initialRoute: initialRoute));
}

String getInitialRoute(String hostname) {
  final parts = hostname.split('-');
  if (parts.length >= 2) {
    final map = parts[1].toLowerCase();
    final type = parts[2];
    if (map == 'tl') {
      if (type == 'unit') {
        return '/testing/unit';
      } else if (type == 'prepare') {
        return '/testing/prepare';
      } else if (type == 'lift') {
        return '/testing/lift';
      }
    } else if (map == 'wl') {
      return '/working/unit';
    }
  }
  // 默认路由
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
