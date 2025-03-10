import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/testing_line/testing_prepare_controller.dart';
import '../../components/control/finder.dart';
import '../../components/navigation/app_bar.dart';
import '../../controllers/config_controller.dart';

class TestingPreparePage extends StatelessWidget {
  const TestingPreparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestingPrepareController>();
    final config = Get.find<ConfigController>();
    final prepareLineName = config.getPrepareLineName();

    return Scaffold(
      appBar: CustomAppBar(
        isCallButtonEnabled: controller.isCallButtonEnabled,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Finder(
              inputValue: controller.inputValue,
              onNumberPressed: controller.onNumberPressed,
              onDelete: controller.handleDelete,
              onReturn: controller.onReturn,
              searchResults: controller.searchResults,
            ),
          ),
          // 底部按钮区域，占 10% 高度
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 5,  // 添加底部边距
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    height: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.sendDownRequest(prepareLineName[0]);
                      },
                      icon: const Icon(Icons.download),
                      label: Text(
                        prepareLineName[0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.sendDownRequest(prepareLineName[1]);
                      },
                      icon: const Icon(Icons.download),
                      label: Text(
                        prepareLineName[1],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 