import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../order/application/order_providers.dart';
import '../../../order/domain/order_model.dart';
import '../../../order/domain/order_status.dart';
import 'widgets/active_order_card.dart';
import 'widgets/order_card.dart';
import 'widgets/status_header.dart';

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
        // 顶部状态与收入栏
        StatusHeader(isOnline: isOnline),
        
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
                    // 过滤数据
                    // 倒序排列，让最新的在最上面
                    final pendingOrders = orders
                        .where((o) => o.status == OrderStatus.pending)
                        .toList(); // 这里可以加 sort
                    
                    final activeOrders = orders
                        .where((o) => o.status == OrderStatus.accepted)
                        .toList();

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
          return OrderCard(order: order);
        } else {
          return ActiveOrderCard(order: order);
        }
      },
    );
  }
}
