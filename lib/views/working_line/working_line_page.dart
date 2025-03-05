import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/base_components.dart';
import '../../components/control/vertical_slider.dart';
import '../../components/navigation/bottom_control_bar.dart';
import '../../controllers/working_line/working_line_device_controller.dart';
import '../../components/control/finder.dart';

class WorkingLinePage extends StatelessWidget {
  const WorkingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkingLineDeviceController>();

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: controller.isWLCallButtonEnabled,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左侧区域 (90%)
          Expanded(
            flex: 90,
            child: Column(
              children: [
                // 上方Finder (90%)
                Expanded(
                  flex: 90,
                  child: Finder(
                    inputValue: controller.wlInputValue,
                    onNumberPressed: controller.handleNumberPressed,
                    onDelete: controller.handleDelete,
                    onReturn: controller.handleSearch,
                    searchResults: [],
                  ),
                ),
                // 底部导航栏 (10%)
                const Expanded(
                  flex: 10,
                  child: BottomControlBar(),
                ),
              ],
            ),
          ),
          // 右侧滑块区域 (10%)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: VerticalSlider(
              sliderValue: controller.wlSliderValue,
              isSettingButtonEnabled: controller.isWLSettingButtonEnabled,
              onSetValue: controller.setSliderValue,
              onSetPosition: controller.setPosition,
            ),
          ),
        ],
      ),
    );
  }
}
