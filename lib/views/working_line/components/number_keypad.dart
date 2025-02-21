import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/main_controller.dart';

class NumberKeypad extends StatelessWidget {
  final MainController controller;

  const NumberKeypad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.inputValue.value,
                        style: const TextStyle(fontSize: 70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${controller.inputValue.value.length}/11',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              children: [
                ...List.generate(
                  9,
                  (index) => NumberButton(
                    number: (index + 1).toString(),
                    onPressed: () =>
                        controller.appendNumber((index + 1).toString()),
                  ),
                ),
                NumberButton(
                  icon: Icons.backspace,
                  onPressed: controller.deleteNumber,
                ),
                NumberButton(
                  number: '0',
                  onPressed: () => controller.appendNumber('0'),
                ),
                NumberButton(
                  icon: Icons.search,
                  onPressed: controller.query,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String? number;
  final IconData? icon;
  final VoidCallback onPressed;

  const NumberButton({
    super.key,
    this.number,
    this.icon,
    required this.onPressed,
  }) : assert(number != null || icon != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: icon != null
            ? Icon(
                icon!,
                size: 48,
                color: icon == Icons.backspace
                    ? Colors.red
                    : icon == Icons.search
                        ? Theme.of(context).primaryColor
                        : theme.iconTheme.color,
              )
            : Text(
                number!,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
