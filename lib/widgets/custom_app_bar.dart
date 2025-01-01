import 'package:flutter/material.dart';
import 'dart:io';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(title),
      ),
      centerTitle: false,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: ()  {
              // 调用系统命令关闭机器
              // await shutdownLinux();
              print("shutdown");
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}