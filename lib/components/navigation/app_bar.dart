import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../controllers/config_controller.dart';
import 'dart:async';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isCallButtonEnabled;
  final RxString currentTime = ''.obs;
  
  CustomAppBar({
    super.key,
    required this.isCallButtonEnabled,
  }) {
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

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

  void _handleUpdate() async {
    final configController = Get.find<ConfigController>();
    
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          '系统更新',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '确定要更新系统吗？更新完成系统将自动重启，请勿断开电源。',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '取消',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '确定',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );

    if (result == true) {
      Process.run('bash', ['-c', 'curl -fsSL ${ConfigController.serverUrl}/download/update.sh | sudo bash'], runInShell: true);
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    currentTime.value = '${now.year}年${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日 '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
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
          Obx(() => Text(
            currentTime.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (value) {
              switch (value) {
                case 'reboot':
                  _handleReboot();
                  break;
                case 'shutdown':
                  _handleShutdown();
                  break;
                case 'update':
                  _handleUpdate();
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
                    Text('重启设备'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'shutdown',
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, color: Colors.red),
                    SizedBox(width: 8),
                    Text('关闭设备'),
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