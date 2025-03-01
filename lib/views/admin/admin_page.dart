import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../components/base_components.dart';
import '../../controllers/admin/admin_controller.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: true.obs,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '传送带',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedLocation.value,
                      decoration: const InputDecoration(
                        labelText: '位置',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.locations.map((String location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedLocation.value = value!,
                    )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedDirection.value,
                      decoration: const InputDecoration(
                        labelText: '方向',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.directions.map((String direction) {
                        return DropdownMenuItem(
                          value: direction,
                          child: Text(direction),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedDirection.value = value!,
                    )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedSpeed.value,
                      decoration: const InputDecoration(
                        labelText: '速度',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.speeds.map((String speed) {
                        return DropdownMenuItem(
                          value: speed,
                          child: Text(speed),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedSpeed.value = value!,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.confirm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('启动'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.stop,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('停止'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              '升降机',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.liftHeightController,
                      decoration: const InputDecoration(
                        labelText: '高度',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                        hintText: '输入5-100之间的数值',
                      ),
                      readOnly: true,
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            child: Container(
                              width: 400,
                              height: 600,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    '请输入高度',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  NumberKeypad(
                                    inputValue: controller.liftHeightInput,
                                    onNumberPressed: (value) {
                                      final currentValue = controller.liftHeightInput.value;
                                      if (currentValue.length < 5) {
                                        controller.liftHeightInput.value += value;
                                      }
                                    },
                                    onDelete: () {
                                      if (controller.liftHeightInput.value.isNotEmpty) {
                                        controller.liftHeightInput.value = controller.liftHeightInput.value
                                            .substring(0, controller.liftHeightInput.value.length - 1);
                                      }
                                    },
                                    onSearch: () {
                                      final number = double.tryParse(controller.liftHeightInput.value);
                                      if (number != null && number >= 5 && number <= 100) {
                                        controller.liftHeightController.text = controller.liftHeightInput.value;
                                        Get.back();
                                      } else {
                                        Get.snackbar('提示', '请输入5-100之间的数值');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          barrierDismissible: true,
                        );
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,1})?$')),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final number = double.tryParse(value);
                          if (number != null) {
                            if (number < 5 || number > 100) {
                              Get.snackbar('提示', '高度必须在5到100之间');
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.setLiftHeight,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('启动'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 