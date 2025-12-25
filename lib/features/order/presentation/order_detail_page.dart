import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/order_model.dart';
import '../domain/order_status.dart';
import '../data/order_repository.dart';

@RoutePage()
class OrderDetailPage extends ConsumerWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听实时订单状态，以防在详情页时被别人抢单了
    // 这里简单起见，我们直接使用传入的 order，但在真实应用中应该根据 ID 监听 Stream
    
    final isPending = order.status == OrderStatus.pending;

    return Scaffold(
      appBar: AppBar(title: const Text('订单详情')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 地图占位符
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 48, color: Colors.grey),
                          Text('地图导航区域'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 标题和价格
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text(
                        '¥ ${order.price}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '距离您 ${order.distance}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const Divider(height: 32),

                  // 路线信息
                  _InfoRow(icon: Icons.my_location, label: '起点', value: order.startLocation),
                  const SizedBox(height: 16),
                  _InfoRow(icon: Icons.location_on, label: '终点', value: order.endLocation),
                  const Divider(height: 32),

                  // 详细描述
                  Text('需求描述', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    order.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          // 底部操作栏
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isPending
                      ? () {
                          ref.read(orderRepositoryProvider).updateOrderStatus(order.id, OrderStatus.accepted);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('抢单成功！请尽快联系雇主。')),
                          );
                          context.router.pop(); // 返回列表
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text(isPending ? '立即抢单' : '该订单已被接取'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
