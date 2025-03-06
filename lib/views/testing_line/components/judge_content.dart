import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/config_controller.dart';
import '../../../controllers/testing_line/testing_line_device_controller.dart';
class JudgeContent extends StatelessWidget {
  final RxString inputValue;
  final List<String> searchResults;

  const JudgeContent({
    super.key,
    required this.inputValue,
    this.searchResults = const [],
  });

  @override
  Widget build(BuildContext context) {
    final configController = Get.find<ConfigController>();
    final controller = Get.find<TestingLineDeviceController>();
    final unitNumber = configController.getLineName().replaceAll(' ', ''); // 获取单元编号

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 左侧查询结果显示区 (50%)
          Expanded(
            flex: 50,
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
                    '当前产品',  // 移除单元信息
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
          // 右侧参数显示区 (50%)
          Expanded(
            flex: 50,
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
                  Text(
                    '${unitNumber} 单元',  // 移除单元信息
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildParameterItem('1号端口气压', '- kPa'),
                        _buildParameterItem('1号端口加压时间', '- s'),
                        _buildParameterItem('2号端口气压', '- kPa'),
                        _buildParameterItem('2号端口加压时间', '- s'),
                        // 使用 Obx 监听数值变化
                        Obx(() => _buildParameterItem(
                          '单元水深',
                          '${controller.unitMm.value.toInt()} mm',
                        )),
                        Obx(() => _buildParameterItem(
                          '单元浑浊度',
                          '${controller.unitNtu.value} NTU',
                        )),
                        Obx(() => _buildParameterItem(
                          '水系统深度',
                          '${controller.pollMm.value.toInt()} mm',
                        )),
                        Obx(() => _buildParameterItem(
                          '水系统浑浊度',
                          '${controller.pollNtu.value} NTU',
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterItem(String label, String value) {
    final parts = value.split(' ');
    final number = parts[0];
    final unit = parts.length > 1 ? ' ${parts[1]}' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // 数值部分 - 改为绿色
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: number != '-' ? Colors.green[600] : Colors.grey[600],  // 使用绿色
            ),
          ),
          // 单位部分
          Text(
            unit,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
