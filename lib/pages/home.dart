import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/vertical_slider.dart';
import '../widgets/vertical_icon_buttons.dart';
import '../widgets/custom_app_bar.dart';
import '../controllers/network_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    Get.put(NetworkController());
    // final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Row(
        children: <Widget>[
          const Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('等待系统初始化...', style: TextStyle(fontSize: 24)),
                Text('System initializing...',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: NumericKeypad(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 500,
                  child: VerticalSlider(
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (double value) {
                      print('Selected value: $value');
                    },
                  ),
                ),
                VerticalIconButtons(
                  onLightPressed: () async {
                    final HomeController controller = Get.find();
                    await controller.toggleLights();
                  },
                  onFanPressed: () {
                    print('Fan button pressed');
                  },
                  onPower12VPressed: () {
                    print('12V power button pressed');
                  },
                  onPower24VPressed: () {
                    print('24V power button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) => FloatingActionButton(
              onPressed: controller.isErrorLoading.value
                  ? null // 当isErrorLoading为true时，按钮将被禁用
                  : () async {
                      await controller.toggleError();
                    },
              tooltip: '通知质检员',
              backgroundColor:
                  controller.isErrorLoading.value ? Colors.grey : Colors.red,
              foregroundColor: Colors.white,
              child: controller.isErrorLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.notifications_active),
            ),
          ),
        ),
      ),
    );
  }
}
