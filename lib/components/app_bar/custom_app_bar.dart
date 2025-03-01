import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isCallButtonEnabled;
  
  const CustomAppBar({
    super.key,
    required this.isCallButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBar(
      backgroundColor: isCallButtonEnabled.value 
          ? Theme.of(context).primaryColor 
          : Colors.red,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Text('HFS'),
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