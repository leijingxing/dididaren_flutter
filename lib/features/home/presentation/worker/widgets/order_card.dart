import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app_router.dart';
import '../../../../order/data/order_repository.dart';
import '../../../../order/domain/order_model.dart';
import '../../../../order/domain/order_status.dart';
import 'address_row.dart';

class OrderCard extends ConsumerWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  IconData _getIconForTitle(String title) {
    if (title.contains('搬')) return Icons.inventory_2_rounded;
    if (title.contains('买') || title.contains('购')) return Icons.shopping_cart_rounded;
    if (title.contains('洁') || title.contains('扫')) return Icons.cleaning_services_rounded;
    if (title.contains('排队')) return Icons.groups_rounded;
    return Icons.work_rounded;
  }

  Color _getIconColor(String title) {
    if (title.contains('搬')) return Colors.blue;
    if (title.contains('买') || title.contains('购')) return Colors.orange;
    if (title.contains('洁') || title.contains('扫')) return Colors.teal;
    return Colors.indigo;
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    return '1天前';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = _getIconForTitle(order.title);
    final iconColor = _getIconColor(order.title);

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.router.push(OrderDetailRoute(order: order));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：图标 + 标题 + 价格
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getTimeAgo(order.createdAt),
                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (order.description.contains('楼') || order.description.contains('重'))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '体力活',
                                  style: TextStyle(fontSize: 10, color: Colors.orange[800]),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${order.price.toInt()}',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        order.distance,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),
              
              // 地址展示
              AddressRow(
                start: order.startLocation,
                end: order.endLocation,
              ),

              const SizedBox(height: 16),
              
              // 按钮区域
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('抢单中...'), duration: Duration(milliseconds: 500)),
                    );
                    Future.delayed(const Duration(milliseconds: 800), () {
                      ref.read(orderRepositoryProvider).updateOrderStatus(order.id, OrderStatus.accepted);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    '立即抢单',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
