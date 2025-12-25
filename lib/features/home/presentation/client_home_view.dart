import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../app_router.dart';
import '../../auth/application/auth_provider.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order_model.dart';
import '../../order/domain/order_status.dart';

class ClientHomeView extends ConsumerStatefulWidget {
  const ClientHomeView({super.key});

  @override
  ConsumerState<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends ConsumerState<ClientHomeView> with TickerProviderStateMixin {
  int _selectedServiceIndex = 0;
  bool _isSearching = false;
  
  // 表单状态
  final TextEditingController _descController = TextEditingController();
  double _price = 30.0;
  bool _isAnalyzing = false; // AI 分析中
  bool _hasPhoto = false; // 是否上传了照片

  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _updateDefaultDesc();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _updateDefaultDesc() {
    switch (_selectedServiceIndex) {
      case 0: _descController.text = '需要搬运几个大箱子到楼上'; _price = 40.0; break;
      case 1: _descController.text = '帮忙去超市买点生活用品'; _price = 20.0; break;
      case 2: _descController.text = '家里需要简单打扫一下'; _price = 50.0; break;
    }
  }

  void _onServiceSelected(int index) {
    setState(() {
      _selectedServiceIndex = index;
      _updateDefaultDesc();
    });
  }

  // 模拟 AI 识别
  void _analyzeOrder() async {
    if (_descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先输入描述或上传照片')));
      return;
    }
    
    setState(() => _isAnalyzing = true);
    
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    setState(() {
      _isAnalyzing = false;
      // 模拟识别结果
      if (_selectedServiceIndex == 0) _price = 88.0; // 搬运贵一点
      if (_descController.text.contains('柜子')) _price += 50; 
      if (_hasPhoto) _price += 10; // 有图加价
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI 估价完成！已根据您的描述调整价格。'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startSearch() {
    setState(() => _isSearching = true);
    _rippleController.repeat();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || !_isSearching) return;
      _createOrder();
      _stopSearch();
    });
  }

  void _stopSearch() {
    if (!mounted) return;
    _rippleController.stop();
    _rippleController.reset();
    setState(() => _isSearching = false);
  }

  void _createOrder() {
    String title = ['搬运服务', '代买服务', '临时杂活'][_selectedServiceIndex];

    final newOrder = Order(
      id: const Uuid().v4(),
      title: title,
      description: _descController.text + (_hasPhoto ? ' [附图]' : ''),
      price: _price,
      distance: '0.5km',
      startLocation: '我的当前位置',
      endLocation: '幸福小区2栋',
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    ref.read(orderRepositoryProvider).addOrder(newOrder);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('订单已发布'),
        content: Text('价格: ¥${_price.toStringAsFixed(0)}\n已通知附近的达人，请耐心等待。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('好的')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 地图层
        Container(
          color: Colors.grey[200],
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 模拟地图元素
              Positioned(
                top: 200, left: 100,
                child: Icon(Icons.location_on, color: Colors.red[300], size: 40),
              ),
              Positioned(
                bottom: 300, right: 80,
                child: Icon(Icons.location_on, color: Colors.blue[300], size: 40),
              ),
              const Center(child: Icon(Icons.map, size: 120, color: Colors.black12)),
              
              if (_isSearching) _RadarRipple(controller: _rippleController),
                
              const Center(child: Icon(Icons.person_pin_circle, size: 50, color: Colors.black87)),
            ],
          ),
        ),

        // 2. 顶部登出
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 16,
          child: Material(
            color: Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black87),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.router.replace(const LoginRoute());
              },
            ),
          ),
        ),

        // 3. 底部操作面板
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5)),
              ],
            ),
            child: SafeArea(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                child: _isSearching ? _buildSearchingView() : _buildOrderForm(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '正在呼叫附近的达人...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'AI 已为您匹配 5 位最合适的达人',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: _stopSearch,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            side: const BorderSide(color: Colors.grey),
          ),
          child: const Text('取消呼叫', style: TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildOrderForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 服务类型选择
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ServiceTab(
                icon: Icons.inventory_2_rounded,
                label: '帮我搬',
                isSelected: _selectedServiceIndex == 0,
                onTap: () => _onServiceSelected(0),
              ),
              const SizedBox(width: 12),
              _ServiceTab(
                icon: Icons.shopping_cart_rounded,
                label: '帮我买',
                isSelected: _selectedServiceIndex == 1,
                onTap: () => _onServiceSelected(1),
              ),
              const SizedBox(width: 12),
              _ServiceTab(
                icon: Icons.cleaning_services_rounded,
                label: '临时工',
                isSelected: _selectedServiceIndex == 2,
                onTap: () => _onServiceSelected(2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 描述输入框 + 拍照按钮
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _descController,
                      maxLines: 3,
                      minLines: 2,
                      decoration: const InputDecoration.collapsed(
                        hintText: '描述您的需求，例如：搬运两个大箱子到5楼...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // 拍照按钮
                  InkWell(
                    onTap: () {
                      setState(() => _hasPhoto = !_hasPhoto);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: _hasPhoto 
                          ? const DecorationImage(image: NetworkImage('https://via.placeholder.com/150'), fit: BoxFit.cover)
                          : null,
                      ),
                      child: _hasPhoto 
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.grey, size: 24),
                                Text('拍照', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),

        // AI 估价区域
        Row(
          children: [
            // AI 按钮
            InkWell(
              onTap: _isAnalyzing ? null : _analyzeOrder,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.blue.shade100]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    if (_isAnalyzing)
                       const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                    else
                       const Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
                    const SizedBox(width: 4),
                    Text(_isAnalyzing ? '分析中...' : 'AI 估价', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // 价格显示与调节
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => setState(() => _price = math.max(10, _price - 5)),
            ),
            Text(
              '¥${_price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setState(() => _price += 5),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 发布按钮
        ElevatedButton(
          onPressed: _startSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('发布需求', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}

// 简化的服务选项卡
class _ServiceTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 雷达波纹动画组件
class _RadarRipple extends StatelessWidget {
  final AnimationController controller;

  const _RadarRipple({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RipplePainter(controller.value),
          size: const Size(400, 400),
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;

  _RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final double offset = i * 0.3;
      final double currentProgress = (progress + offset) % 1.0;
      final double radius = maxRadius * currentProgress;
      final double opacity = 1.0 - currentProgress;

      paint.color = Colors.deepOrange.withOpacity(opacity * 0.5);
      paint.strokeWidth = 2 + (4 * currentProgress);

      canvas.drawCircle(center, radius, paint);
      
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.deepOrange.withOpacity(opacity * 0.1);
      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}