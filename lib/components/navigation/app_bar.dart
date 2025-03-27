import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../controllers/config_controller.dart';
import 'dart:async';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isCallButtonEnabled;
  final RxString currentTime = ''.obs;
  final String? title;
  
  CustomAppBar({
    super.key,
    required this.isCallButtonEnabled,
    this.title,
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
      Process.run('sudo', ['reboot'], runInShell: true);
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
      Process.run('sudo', ['shutdown', '-h', 'now'], runInShell: true);
    }
  }

  void _showSystemInfo() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          '系统信息',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: 700,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/pttoo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '匹兔® 智慧工厂系统',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '版本: 1.0.0',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '授权信息',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('授权于', '江苏恒久滚塑制品有限公司'),
              _buildInfoRow('时间', '开始于2023-05-01，永久有效'),
              _buildInfoRow('客户服务', 'service@viirose.com'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '授权内容和知识产权: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '本系统包括软件、网络设备、服务器、存储、机柜等，其商标为本《信息》中的兔子图标、'
                      '花形图标、七薇、匹兔、VIIROSE中之一或者其组合，其知识产权归上海翠薇智能科技有限公司所有。软件著作权所有人为上海翠薇智能科技有限公司，共有人为江苏恒久滚塑制品有限公司。',
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '© 2017-2025 上海翠薇智能科技有限公司',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '关闭',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
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
          Text(title ?? 'HFS'),
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
                  onPressed: () {
                    if (Get.isRegistered<dynamic>() && 
                        Get.find<dynamic>().handleCall != null) {
                      Get.find<dynamic>().handleCall();
                    }
                  },
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
                case 'info':
                  _showSystemInfo();
                  break;
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
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('系统信息'),
                  ],
                ),
              ),
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