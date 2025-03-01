import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/base_components.dart';
import 'components/left_control_panel.dart';
import 'components/main_content.dart';
import 'components/number_keypad.dart';
import 'components/slider_panel.dart';
import '../../controllers/working_line/working_line_controller.dart';
import '../../controllers/working_line/device_controller.dart';

class WorkingLinePage extends StatelessWidget {
  const WorkingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final workingLineController = Get.put(WorkingLineController());
    final deviceController = Get.put(DeviceController());

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: deviceController.isCallButtonEnabled,
      ),
      body: Stack(
        children: [
          Row(
            children: [
              MainContent(controller: workingLineController),
              NumberKeypad(controller: workingLineController),
              SliderPanel(
                sliderValue: deviceController.sliderValue,
                isSettingButtonEnabled: deviceController.isSettingButtonEnabled,
                onSetValue: deviceController.setSliderValue,
              ),
            ],
          ),
          const LeftControlPanel(),
        ],
      ),
    );
  }
}
