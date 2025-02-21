import 'package:flutter/material.dart';

class LeftControlPanel extends StatelessWidget {
  const LeftControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Row(
        children: [
          FloatingActionButton(
            heroTag: 'call',
            onPressed: () {},
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
            child: const Icon(Icons.call),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'light',
            onPressed: () {},
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            child: const Icon(Icons.lightbulb),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'fan',
            onPressed: () {},
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.air),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'load',
            onPressed: () {},
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.download),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () {},
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.upload),
          ),
          const SizedBox(width: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(153),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Text('操作台高度: 75cm  ', style: TextStyle(color: Colors.white)),
                Text('灯光状态: 开启  ', style: TextStyle(color: Colors.white)),
                Text('风扇状态: -  ', style: TextStyle(color: Colors.white)),
                Text('环境湿度: -  ', style: TextStyle(color: Colors.white)),
                Text('环境温度: -', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
