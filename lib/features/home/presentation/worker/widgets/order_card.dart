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
    if (title.contains('搬')) return const Color(0xFF2B65E3); // Tech Blue
    if (title.contains('买') || title.contains('购')) return const Color(0xFFFF9F1C); // Orange
    if (title.contains('洁') || title.contains('扫')) return const Color(0xFF2EC4B6); // Teal
    return const Color(0xFF6B5B95); // Purple
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.router.push(OrderDetailRoute(order: order));
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部：图标 + 标题 + 价格
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: iconColor, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _Tag(
                                text: _getTimeAgo(order.createdAt),
                                color: Colors.grey[100]!,
                                textColor: Colors.grey[600]!,
                              ),
                              if (order.description.contains('楼') || order.description.contains('重')) ...[
                                const SizedBox(width: 8),
                                _Tag(
                                  text: '体力活',
                                  color: Colors.orange.shade50,
                                  textColor: Colors.orange.shade800,
                                ),
                              ],
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
                          style: const TextStyle(
                            color: Color(0xFFE63946), // Red
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.near_me_rounded, size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 2),
                            Text(
                              order.distance,
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                ),
                
                // 地址展示
                AddressRow(
                  start: order.startLocation,
                  end: order.endLocation,
                ),

                const SizedBox(height: 20),
                
                // 按钮区域
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('抢单中...'), 
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                      Future.delayed(const Duration(milliseconds: 800), () {
                        ref.read(orderRepositoryProvider).updateOrderStatus(order.id, OrderStatus.accepted);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B2D42), // Dark Blue Grey
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      shadowColor: Colors.black.withOpacity(0.2),
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
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Tag({required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
