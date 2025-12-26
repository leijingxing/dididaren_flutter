import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/order_providers.dart';
import '../data/order_repository.dart';
import '../domain/order_model.dart';
import '../domain/order_status.dart';

@RoutePage()
class ClientOrderDetailPage extends ConsumerWidget {
  final Order order;

  const ClientOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);

    return ordersAsync.when(
      data: (orders) {
        final currentOrder =
            orders.firstWhere((o) => o.id == order.id, orElse: () => order);
        return _buildContent(context, ref, currentOrder);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('订单详情')),
        body: Center(child: Text('加载失败: $err')),
      ),
    );
  }

  Scaffold _buildContent(BuildContext context, WidgetRef ref, Order order) {
    final statusStyle = _statusStyle(order.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('订单详情'),
        centerTitle: true,
      ),
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                          SizedBox(height: 6),
                          Text('地图导航区域'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 状态卡片
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusStyle.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: statusStyle.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: statusStyle.iconBg,
                          child: Icon(statusStyle.icon, color: statusStyle.iconColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusStyle.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                statusStyle.subTitle,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 订单基本信息
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
                  const SizedBox(height: 6),
                  Text(
                    '距离您 ${order.distance}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const Divider(height: 32),

                  // 路线信息
                  _InfoRow(
                    icon: Icons.my_location,
                    label: '起点',
                    value: order.startLocation,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.location_on,
                    label: '终点',
                    value: order.endLocation,
                  ),
                  const Divider(height: 32),

                  // 需求描述
                  Text('需求描述', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    order.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // 达人信息（模拟）
                  Text('达人信息', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _buildWorkerCard(order.status),
                ],
              ),
            ),
          ),

          // 底部操作区
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _primaryAction(context, ref, order),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: statusStyle.primaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(statusStyle.primaryText),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已为你联系平台客服')),
                      );
                    },
                    child: const Text('联系平台客服'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _primaryAction(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) {
    if (order.status == OrderStatus.pending) {
      return () {
        ref
            .read(orderRepositoryProvider)
            .updateOrderStatus(order.id, OrderStatus.cancelled);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('订单已取消')),
        );
      };
    }

    if (order.status == OrderStatus.accepted) {
      return () {
        ref
            .read(orderRepositoryProvider)
            .updateOrderStatus(order.id, OrderStatus.completed);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已确认完成服务')),
        );
      };
    }

    if (order.status == OrderStatus.cancelled) {
      return () => Navigator.pop(context);
    }

    return null;
  }

  Widget _buildWorkerCard(OrderStatus status) {
    if (status == OrderStatus.pending) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[100]!),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orange,
              child: Icon(Icons.search, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '正在匹配附近达人，请稍等',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    if (status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '订单已取消，如需帮助可重新发布需求。',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=dididaren-worker',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '王师傅 · 4.9 分',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('已完成 128 单 · 预计 10 分钟到达'),
              ],
            ),
          ),
          Icon(Icons.phone, color: Colors.blue[700]),
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

class _StatusStyle {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color background;
  final Color border;
  final Color primaryColor;
  final String primaryText;

  const _StatusStyle({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.background,
    required this.border,
    required this.primaryColor,
    required this.primaryText,
  });
}

_StatusStyle _statusStyle(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return const _StatusStyle(
        title: '等待接单',
        subTitle: '系统正在呼叫附近达人',
        icon: Icons.schedule,
        iconBg: Color(0xFFFFF3E0),
        iconColor: Color(0xFFF57C00),
        background: Color(0xFFFFFBF5),
        border: Color(0xFFFFE0B2),
        primaryColor: Color(0xFFE53935),
        primaryText: '取消订单',
      );
    case OrderStatus.accepted:
      return const _StatusStyle(
        title: '达人已接单',
        subTitle: '预计 10 分钟到达',
        icon: Icons.directions_run,
        iconBg: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32),
        background: Color(0xFFF4FBF5),
        border: Color(0xFFC8E6C9),
        primaryColor: Color(0xFF2E7D32),
        primaryText: '确认完成',
      );
    case OrderStatus.completed:
      return const _StatusStyle(
        title: '订单已完成',
        subTitle: '感谢使用滴滴达人',
        icon: Icons.check_circle,
        iconBg: Color(0xFFE8F5E9),
        iconColor: Color(0xFF2E7D32),
        background: Color(0xFFF4FBF5),
        border: Color(0xFFC8E6C9),
        primaryColor: Color(0xFF9E9E9E),
        primaryText: '订单已完成',
      );
    case OrderStatus.cancelled:
      return const _StatusStyle(
        title: '订单已取消',
        subTitle: '可重新发布需求',
        icon: Icons.cancel,
        iconBg: Color(0xFFF5F5F5),
        iconColor: Color(0xFF616161),
        background: Color(0xFFF8F8F8),
        border: Color(0xFFE0E0E0),
        primaryColor: Color(0xFF616161),
        primaryText: '返回',
      );
  }
}
