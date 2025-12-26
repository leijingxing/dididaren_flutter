import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/order_model.dart';
import '../domain/order_status.dart';
import '../data/order_repository.dart';
import 'widgets/order_status_timeline.dart';
import 'widgets/order_info_section.dart';

@RoutePage()
class ActiveOrderDetailPage extends ConsumerStatefulWidget {
  final String initialOrderId;
  final List<Order> activeOrders;

  const ActiveOrderDetailPage({
    super.key,
    required this.initialOrderId,
    required this.activeOrders,
  });

  @override
  ConsumerState<ActiveOrderDetailPage> createState() => _ActiveOrderDetailPageState();
}

class _ActiveOrderDetailPageState extends ConsumerState<ActiveOrderDetailPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.activeOrders.indexWhere((o) => o.id == widget.initialOrderId);
    _currentIndex = initialIndex >= 0 ? initialIndex : 0;
    _pageController = PageController(initialPage: _currentIndex, viewportFraction: 0.95);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '进行中任务 (${_currentIndex + 1}/${widget.activeOrders.length})',
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. 全屏地图背景 (模拟)
          Positioned.fill(
            child: Image.network(
              'https://miro.medium.com/v2/resize:fit:1200/1*qYUvh-EtES8dtgKiBRiLsA.png', 
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.1),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          
          // 2. 页面内容 (PageView)
          PageView.builder(
            controller: _pageController,
            itemCount: widget.activeOrders.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final order = widget.activeOrders[index];
              return _buildOrderPage(order);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPage(Order order) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4), // PageView gap
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5)),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 拖拽手柄
                      Center(
                        child: Container(
                          width: 40, 
                          height: 4, 
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      
                      // 状态时间轴
                      OrderStatusTimeline(status: order.status),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // 订单核心信息
                      OrderInfoSection(order: order),
                      
                      const SizedBox(height: 32),

                      // 操作按钮组
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                             ref.read(orderRepositoryProvider).updateOrderStatus(order.id, OrderStatus.completed);
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('订单已完成')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text('确认完成服务', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('遇到问题 / 取消订单', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      // 底部留白
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
