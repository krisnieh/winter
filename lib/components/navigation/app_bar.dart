import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../controllers/config_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isCallButtonEnabled;
  
  const CustomAppBar({
    super.key,
    required this.isCallButtonEnabled,
  });

  void _handleReboot() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('系统重启'),
        content: const Text('确定要重启系统吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result == true) {
      Process.run('reboot', [], runInShell: true);
    }
  }

  void _handleShutdown() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('系统关机'),
        content: const Text('确定要关闭系统吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result == true) {
      Process.run('shutdown', ['-h', 'now'], runInShell: true);
    }
  }

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              switch (value) {
                case 'reboot':
                  _handleReboot();
                  break;
                case 'shutdown':
                  _handleShutdown();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reboot',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('重启系统'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'shutdown',
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, color: Colors.red),
                    SizedBox(width: 8),
                    Text('关闭系统'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 