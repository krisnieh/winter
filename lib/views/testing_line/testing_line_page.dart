import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/testing_line/device_controller.dart';
import 'components/custom_app_bar.dart';
import 'components/left_control_panel.dart';

class TestingLinePage extends StatelessWidget {
  const TestingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注入控制器
    Get.put(TestingDeviceController());

    return const Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          LeftControlPanel(),
        ],
      ),
    );
  }
} 