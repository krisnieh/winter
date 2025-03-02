import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/config_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isCallButtonEnabled;
  
  const CustomAppBar({
    super.key,
    required this.isCallButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<ConfigController>();

    return Obx(() => AppBar(
      backgroundColor: isCallButtonEnabled.value 
          ? Theme.of(context).primaryColor 
          : Colors.red,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Text('HFS'),
          const SizedBox(width: 8),
          Obx(() => Text(
            configController.lineName.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.person_pin),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 