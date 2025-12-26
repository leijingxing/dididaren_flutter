import 'package:flutter/material.dart';
import '../../domain/order_model.dart';
import '../../domain/order_status.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // 定义状态步骤
    // final steps = [
    //   {'label': '已接单', 'status': OrderStatus.accepted},
    //   {'label': '进行中', 'status': OrderStatus.accepted}, // 假设有这个中间状态，或者统称为 accepted
    //   {'label': '已完成', 'status': OrderStatus.completed},
    // ];

    // 简化逻辑：如果是 accepted 算第一步完成，completed 算全部完成
    int currentStep = 0;
    if (status == OrderStatus.completed) {
      currentStep = 3;
    } else if (status == OrderStatus.accepted) {
      currentStep = 1;
    }

    return Row(
      children: [
        _buildStep('已接单', true, true),
        _buildLine(true),
        _buildStep('前往中', true, currentStep >= 1), // 模拟中间状态
        _buildLine(currentStep >= 2),
        _buildStep('服务中', currentStep >= 2, currentStep >= 2),
        _buildLine(currentStep >= 3),
        _buildStep('已完成', currentStep >= 3, currentStep >= 3),
      ],
    );
  }

  Widget _buildStep(String label, bool isActive, bool isCompleted) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isCompleted ? Colors.green : (isActive ? Colors.blue : Colors.grey[300]),
          child: isCompleted 
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : (isActive ? const CircleAvatar(radius: 4, backgroundColor: Colors.white) : null),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.black87 : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.green : Colors.grey[300],
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10), // 调整位置对齐圆圈
        alignment: Alignment.topCenter,
      ),
    );
  }
}
