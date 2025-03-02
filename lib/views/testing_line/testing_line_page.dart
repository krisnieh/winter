import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/base_components.dart';
import '../../components/control/vertical_slider.dart';
import '../../components/navigation/bottom_control_bar.dart';
import '../../controllers/testing_line/testing_line_device_controller.dart';
import 'components/judge_content.dart';

class TestingLinePage extends StatelessWidget {
  const TestingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestingLineDeviceController>();

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: controller.isTLCallButtonEnabled,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左侧区域 (90%)
          Expanded(
            flex: 90,
            child: Column(
              children: [
                // 上方 JudgeContent (90%)
                Expanded(
                  flex: 90,
                  child: JudgeContent(
                    inputValue: controller.tlInputValue,
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
              sliderValue: controller.tlSliderValue,
              isSettingButtonEnabled: controller.isTLSettingButtonEnabled,
              onSetValue: controller.setSliderValue,
            ),
          ),
        ],
      ),
    );
  }
}
