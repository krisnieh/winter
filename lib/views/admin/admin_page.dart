import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin/admin_controller.dart';
import '../../components/base_components.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'HSF',
        isCallButtonEnabled: controller.isCallButtonEnabled,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 传送带控制
            _buildSectionTitle('传送带'),
            const SizedBox(height: 16),
            Row(
              children: [
                // 南传送带控制
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('南', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          // 速度滑块
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('速度:'),
                              Obx(() => Slider(
                                value: controller.southConveyorSpeed.value.toDouble(),
                                min: 1,
                                max: 100,
                                divisions: 99,
                                label: controller.southConveyorSpeed.value.toString(),
                                onChanged: (value) => controller.southConveyorSpeed.value = value.toInt(),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 方向选择
                          Row(
                            children: [
                              const Text('方向:'),
                              const SizedBox(width: 8),
                              Obx(() => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'UP',
                                    groupValue: controller.southConveyorDirection.value,
                                    onChanged: (value) => controller.southConveyorDirection.value = value!,
                                  ),
                                  const Text('向上'),
                                  Radio<String>(
                                    value: 'DOWN',
                                    groupValue: controller.southConveyorDirection.value,
                                    onChanged: (value) => controller.southConveyorDirection.value = value!,
                                  ),
                                  const Text('向下'),
                                ],
                              )),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // 控制按钮
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () => controller.startSouthConveyor(),
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                child: const Text('启动'),
                              ),
                              ElevatedButton(
                                onPressed: () => controller.stopSouthConveyor(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('停止'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 北传送带控制
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('北', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          // 速度滑块
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('速度:'),
                              Obx(() => Slider(
                                value: controller.northConveyorSpeed.value.toDouble(),
                                min: 1,
                                max: 100,
                                divisions: 99,
                                label: controller.northConveyorSpeed.value.toString(),
                                onChanged: (value) => controller.northConveyorSpeed.value = value.toInt(),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 方向选择
                          Row(
                            children: [
                              const Text('方向:'),
                              const SizedBox(width: 8),
                              Obx(() => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'UP',
                                    groupValue: controller.northConveyorDirection.value,
                                    onChanged: (value) => controller.northConveyorDirection.value = value!,
                                  ),
                                  const Text('向上'),
                                  Radio<String>(
                                    value: 'DOWN',
                                    groupValue: controller.northConveyorDirection.value,
                                    onChanged: (value) => controller.northConveyorDirection.value = value!,
                                  ),
                                  const Text('向下'),
                                ],
                              )),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // 控制按钮
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () => controller.startNorthConveyor(),
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                child: const Text('启动'),
                              ),
                              ElevatedButton(
                                onPressed: () => controller.stopNorthConveyor(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('停止'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // 升降机控制
            _buildSectionTitle('升降机'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('高度控制', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Obx(() => Slider(
                            value: controller.liftHeight.value,
                            min: 1,
                            max: 100,
                            divisions: 990, // 步长0.1的划分
                            label: controller.liftHeight.value.toStringAsFixed(1),
                            onChanged: (value) => controller.liftHeight.value = double.parse(value.toStringAsFixed(1)),
                          )),
                          Text('高度: ${controller.liftHeight.value.toStringAsFixed(1)}'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: controller.startLift,
                                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                child: const Text('启动'),
                              ),
                              ElevatedButton(
                                onPressed: controller.emergencyStopLift,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('紧急停止'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // 检测单元
            _buildSectionTitle('检测单元'),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDetectionUnit('A', controller),
                _buildDetectionUnit('B', controller),
                _buildDetectionUnit('C', controller),
                _buildDetectionUnit('D', controller),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // 水池控制
            _buildSectionTitle('水池'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text('水池水位: ${controller.poolWaterLevel.value} mm', 
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSwitch('排水泵', controller.isDrainPumpOn),
                              _buildSwitch('注水泵', controller.isFillPumpOn),
                              _buildSwitch('自来水开关', controller.isWaterValveOn),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildDetectionUnit(String unit, AdminController controller) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('单元 $unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() {
                // 根据单元获取相应的数据
                int waterLevel = 0;
                double turbidity = 0;
                
                switch(unit) {
                  case 'A':
                    waterLevel = controller.unitAWaterLevel.value;
                    turbidity = controller.unitATurbidity.value / 100;
                    break;
                  case 'B':
                    waterLevel = controller.unitBWaterLevel.value;
                    turbidity = controller.unitBTurbidity.value / 100;
                    break;
                  case 'C':
                    waterLevel = controller.unitCWaterLevel.value;
                    turbidity = controller.unitCTurbidity.value / 100;
                    break;
                  case 'D':
                    waterLevel = controller.unitDWaterLevel.value;
                    turbidity = controller.unitDTurbidity.value / 100;
                    break;
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('水位: $waterLevel mm'),
                    Text('浑浊度: $turbidity NTU'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildUnitSwitch('进水', unit, true, controller),
                        _buildUnitSwitch('排水', unit, false, controller),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildUnitSwitch(String label, String unit, bool isWaterIn, AdminController controller) {
    return Row(
      children: [
        Text(label),
        Obx(() {
          bool value = false;
          
          // 根据单元和开关类型获取对应的值
          if (isWaterIn) {
            switch(unit) {
              case 'A': value = controller.isUnitAWaterInOn.value; break;
              case 'B': value = controller.isUnitBWaterInOn.value; break;
              case 'C': value = controller.isUnitCWaterInOn.value; break;
              case 'D': value = controller.isUnitDWaterInOn.value; break;
            }
          } else {
            switch(unit) {
              case 'A': value = controller.isUnitAWaterOutOn.value; break;
              case 'B': value = controller.isUnitBWaterOutOn.value; break;
              case 'C': value = controller.isUnitCWaterOutOn.value; break;
              case 'D': value = controller.isUnitDWaterOutOn.value; break;
            }
          }
          
          return Switch(
            value: value,
            onChanged: (newValue) => controller.toggleUnitWaterSwitch(unit, isWaterIn, newValue),
          );
        }),
      ],
    );
  }
  
  Widget _buildSwitch(String label, RxBool isOn) {
    return Row(
      children: [
        Text(label),
        Obx(() => Switch(
          value: isOn.value,
          onChanged: (value) {
            // 根据标签确定调用哪个方法
            if (label == '排水泵') {
              Get.find<AdminController>().toggleDrainPump(value);
            } else if (label == '注水泵') {
              Get.find<AdminController>().toggleFillPump(value);
            } else if (label == '自来水开关') {
              Get.find<AdminController>().toggleWaterValve(value);
            } else {
              isOn.value = value; // 默认行为
            }
          },
        )),
      ],
    );
  }
} 