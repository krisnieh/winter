import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/base_components.dart';
import '../../controllers/working_line/device_controller.dart';

class WorkingLinePage extends StatelessWidget {
  const WorkingLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceController>();

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: controller.isCallButtonEnabled,
      ),
      body: Stack(
        children: [
          Row(
            children: [
              NumberKeypad(
                inputValue: controller.inputValue,
                onNumberPressed: controller.handleNumberPressed,
                onDelete: controller.handleDelete,
                onSearch: controller.handleSearch,
              ),
              SliderPanel(
                sliderValue: controller.sliderValue,
                isSettingButtonEnabled: controller.isSettingButtonEnabled,
                onSetValue: controller.setSliderValue,
              ),
            ],
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Row(
              children: [
                Obx(() => FloatingActionButton(
                      heroTag: 'call',
                      onPressed: controller.isCallButtonEnabled.value
                          ? controller.triggerCall
                          : null,
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.call),
                    )),
                const SizedBox(width: 16),
                Obx(() => FloatingActionButton(
                      heroTag: 'light',
                      onPressed: controller.isLightButtonEnabled.value
                          ? controller.toggleLight
                          : null,
                      backgroundColor: controller.isLightOn.value
                          ? Colors.amber[700]
                          : Colors.grey[300],
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.lightbulb),
                    )),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'fan',
                  onPressed: null,
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[600],
                  child: const Icon(Icons.air),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
