import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NumberKeypad extends StatelessWidget {
  final RxString inputValue;
  final Function(String) onNumberPressed;
  final VoidCallback onDelete;
  final VoidCallback onSearch;

  const NumberKeypad({
    super.key,
    required this.inputValue,
    required this.onNumberPressed,
    required this.onDelete,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: Obx(() => FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    inputValue.value,
                    style: const TextStyle(fontSize: 70),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${inputValue.value.length}/11',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
        Expanded(
          flex: 5,
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ...List.generate(
                9,
                (index) => NumberButton(
                  number: (index + 1).toString(),
                  onPressed: () => onNumberPressed((index + 1).toString()),
                ),
              ),
              NumberButton(
                icon: Icons.backspace,
                onPressed: onDelete,
              ),
              NumberButton(
                number: '0',
                onPressed: () => onNumberPressed('0'),
              ),
              NumberButton(
                icon: Icons.keyboard_return,
                onPressed: onSearch,
              ),
            ],
          ),
        ),
      ],
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