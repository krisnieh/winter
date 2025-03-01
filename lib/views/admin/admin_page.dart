import 'package:flutter/material.dart';
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
        isCallButtonEnabled: true.obs,  // 管理页面不需要变红
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedLine.value,
                      decoration: const InputDecoration(
                        labelText: '产线',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.lines.map((String line) {
                        return DropdownMenuItem(
                          value: line,
                          child: Text(line),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedLine.value = value!,
                    )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedType.value,
                      decoration: const InputDecoration(
                        labelText: '类型',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.types.map((String type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedType.value = value!,
                    )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedUnit.value,
                      decoration: const InputDecoration(
                        labelText: '单元',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.units.map((String unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) => controller.selectedUnit.value = value!,
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
                    child: const Text('确认'),
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