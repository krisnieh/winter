import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import 'components/custom_app_bar.dart';
import 'components/left_control_panel.dart';
import 'components/main_content.dart';
import 'components/number_keypad.dart';
import 'components/slider_panel.dart';

class WorkingLinePage extends StatelessWidget {
  const WorkingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Row(
            children: [
              MainContent(controller: controller),
              NumberKeypad(controller: controller),
              SliderPanel(controller: controller),
            ],
          ),
          const LeftControlPanel(),
        ],
      ),
    );
  }
}
