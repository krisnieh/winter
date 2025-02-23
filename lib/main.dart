import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/working_line/working_line_page.dart';
import 'services/mqtt_service.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  FullScreen.setFullScreen(true);
  Get.put(MqttService()); // 直接注入服务，不需要等待初始化
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HenjouSmartFactory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const WorkingLinePage(),
    );
  }
}
