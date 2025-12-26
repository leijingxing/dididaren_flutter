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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Blue-Grey background
      body: Column(
        children: [
          // 顶部状态与收入栏
          StatusHeader(isOnline: isOnline),
          
          const SizedBox(height: 16),

          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicator: BoxDecoration(
                color: const Color(0xFF2B2D42),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: const [
                Tab(text: '抢单大厅'),
                Tab(text: '进行中任务'),
              ],
            ),
          ),

          // 订单列表区域
          Expanded(
            child: !isOnline
                ? _buildOfflineState()
                : ordersAsync.when(
                    data: (orders) {
                      final pendingOrders = orders
                          .where((o) => o.status == OrderStatus.pending)
                          .toList(); 
                      
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
      ),
    );
  }

  Widget _buildOfflineState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.power_settings_new_rounded, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            '已停止听单', 
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            )
          ),
          const SizedBox(height: 8),
          Text(
            '开启听单后，新订单将实时推送到这里', 
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, {required bool isPendingTab}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.network(
                isPendingTab 
                    ? 'https://cdn-icons-png.flaticon.com/512/7486/7486744.png' // Placeholder for empty list
                    : 'https://cdn-icons-png.flaticon.com/512/7486/7486754.png', // Placeholder for no tasks
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => 
                    Icon(isPendingTab ? Icons.hourglass_empty : Icons.assignment_turned_in, size: 80, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isPendingTab ? '暂无新订单' : '当前没有进行中的任务', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              )
            ),
            if (isPendingTab)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('请保持在线，稍后会有新单推送', style: TextStyle(color: Colors.grey[400])),
              ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 80), // Bottom padding to avoid FAB overlap if any
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
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
