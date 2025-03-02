import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Finder extends StatelessWidget {
  final RxString inputValue;
  final Function(String) onNumberPressed;
  final VoidCallback onDelete;
  final VoidCallback onReturn;
  final List<String> searchResults;  // 添加查询结果列表

  const Finder({
    super.key,
    required this.inputValue,
    required this.onNumberPressed,
    required this.onDelete,
    required this.onReturn,
    this.searchResults = const [],  // 默认为空列表
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 左侧查询结果显示区
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '查询结果',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              searchResults[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 右侧数字键盘区
          Container(
            width: 500,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,  // 改为顶部对齐
              children: [
                // 数字显示区
                Container(
                  height: 160,
                  width: double.infinity,  // 确保宽度填充父容器
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,  // 确保子元素横向拉伸
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                          inputValue.value,
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        '${inputValue.value.length}/11',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,  // 修改为居中对齐
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 数字键盘
                Expanded(  // 使用 Expanded 替代固定高度的 SizedBox
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...List.generate(9, (index) {
                        return _buildButton(
                          text: '${index + 1}',
                          onPressed: () => onNumberPressed('${index + 1}'),
                        );
                      }),
                      _buildButton(
                        icon: Icons.backspace,
                        onPressed: onDelete,
                        color: Colors.red[400],
                        iconColor: Colors.white,
                      ),
                      _buildButton(
                        text: '0',
                        onPressed: () => onNumberPressed('0'),
                      ),
                      _buildButton(
                        icon: Icons.keyboard_return,
                        onPressed: onReturn,
                        color: Colors.blue[400],
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    Color? color,
    Color? iconColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[100],
        foregroundColor: color != null ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.zero,
      ),
      child: icon != null
          ? Icon(icon, size: 32, color: iconColor)
          : Text(
              text!,
              style: const TextStyle(fontSize: 32),
            ),
    );
  }
}
