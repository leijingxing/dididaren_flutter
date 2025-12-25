import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../order/data/order_repository.dart';
import '../../../../order/domain/order_model.dart';
import '../../../../order/domain/order_status.dart';

class ActiveOrderCard extends ConsumerWidget {
  final Order order;
  const ActiveOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue[200]!, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.directions_run, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('任务进行中', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const Spacer(),
                Text('¥${order.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(order.description),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: const Text('联系雇主'),
                    onPressed: () {}, // 模拟打电话
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('确认完成'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      ref.read(orderRepositoryProvider).updateOrderStatus(order.id, OrderStatus.completed);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('恭喜！订单已完成，佣金已到账。')));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
