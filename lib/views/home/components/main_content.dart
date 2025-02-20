import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/main_controller.dart';

class MainContent extends StatelessWidget {
  final MainController controller;

  const MainContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Obx(() => Text(
              controller.queryResult.value,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
      ),
    );
  }
}
