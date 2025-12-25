import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../app_router.dart';
import '../../auth/application/auth_provider.dart';
import '../../order/application/order_providers.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order_model.dart';
import '../../order/domain/order_status.dart';

// 使用 StateProvider 管理本地的“在线/离线”状态
final isOnlineProvider = StateProvider<bool>((ref) => true);

class WorkerHomeView extends ConsumerStatefulWidget {
  const WorkerHomeView({super.key});

  @override
  ConsumerState<WorkerHomeView> createState() => _WorkerHomeViewState();
}

class _WorkerHomeViewState extends ConsumerState<WorkerHomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderListProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Column(
      children: [
        // 顶部状态与收入栏 (保持不变)
        _StatusHeader(isOnline: isOnline),
        
        // Tab 栏
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: '抢单大厅'),
              Tab(text: '进行中'),
            ],
          ),
        ),

        // 订单列表区域
        Expanded(
          child: !isOnline
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.coffee, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('已停止听单，休息一下吧', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ordersAsync.when(
                  data: (orders) {
                    final pendingOrders = orders.where((o) => o.status == OrderStatus.pending).toList();
                    final activeOrders = orders.where((o) => o.status == OrderStatus.accepted).toList();

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: 抢单大厅
                        _buildOrderList(pendingOrders, isPendingTab: true),
                        
                        // Tab 2: 进行中
                        _buildOrderList(activeOrders, isPendingTab: false),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<Order> orders, {required bool isPendingTab}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isPendingTab ? Icons.hourglass_empty : Icons.assignment_turned_in, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(isPendingTab ? '暂无新订单' : '当前没有进行中的任务', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        if (isPendingTab) {
          return _OrderCard(order: order);
        } else {
          return _ActiveOrderCard(order: order); // 使用专门的卡片样式
        }
      },
    );
  }
}

class _StatusHeader extends ConsumerWidget {
  final bool isOnline;

  const _StatusHeader({required this.isOnline});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
      decoration: BoxDecoration(
        color: isOnline ? colorScheme.primaryContainer : Colors.grey[200],
        // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)), // 取消圆角，为了连接 TabBar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日收入 (元)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOnline ? colorScheme.onPrimaryContainer.withOpacity(0.7) : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '128.50',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Monospace',
                          color: isOnline ? colorScheme.onPrimaryContainer : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                   Column(
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: isOnline,
                          onChanged: (val) => ref.read(isOnlineProvider.notifier).state = val,
                          activeColor: colorScheme.primary,
                        ),
                      ),
                      Text(
                        isOnline ? '听单中' : '已休息',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOnline ? Colors.green[700] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.logout, color: isOnline ? colorScheme.onPrimaryContainer : Colors.grey[600]),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.router.replace(const LoginRoute());
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 专门为“进行中”订单设计的卡片
class _ActiveOrderCard extends ConsumerWidget {
  final Order order;
  const _ActiveOrderCard({required this.order});

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

class _OrderCard extends ConsumerWidget {
  final Order order;

  const _OrderCard({required this.order});

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
              
              // 地址展示：起点 -> 终点
              _AddressRow(
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

class _AddressRow extends StatelessWidget {
  final String start;
  final String end;

  const _AddressRow({required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 12, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(child: Text(start, style: const TextStyle(color: Colors.black87, fontSize: 13))),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.5),
          padding: const EdgeInsets.symmetric(vertical: 2),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 12,
            width: 1,
            color: Colors.grey[300],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.circle, size: 12, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(child: Text(end, style: const TextStyle(color: Colors.black87, fontSize: 13))),
          ],
        ),
      ],
    );
  }
}