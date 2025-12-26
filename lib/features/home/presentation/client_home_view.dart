import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../app_router.dart';
import '../../auth/application/auth_provider.dart';
import '../../order/data/order_repository.dart';
import '../../order/domain/order_model.dart';
import '../../order/domain/order_status.dart';
import 'widgets/order_form_panel.dart';
import 'widgets/radar_ripple.dart';
import 'widgets/searching_view.dart';

/// 客户端主页视图
/// 包含地图背景、状态展示和订单操作面板
class ClientHomeView extends ConsumerStatefulWidget {
  const ClientHomeView({super.key});

  @override
  ConsumerState<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends ConsumerState<ClientHomeView> with TickerProviderStateMixin {
  // 业务状态
  int _selectedServiceIndex = 0;
  bool _isSearching = false;
  
  // 表单数据
  final TextEditingController _descController = TextEditingController();
  double _price = 30.0;
  bool _isAnalyzing = false; // AI 分析中
  bool _hasPhoto = false; // 是否上传了照片

  // 动画控制器
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

  /// 根据选择的服务更新默认描述和价格
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

  // 模拟 AI 识别逻辑
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
      // 模拟简单的估价逻辑
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

  /// 开始呼叫达人
  void _startSearch() {
    setState(() => _isSearching = true);
    _rippleController.repeat();

    // 模拟匹配过程
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

  /// 创建订单
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

    final router = context.router;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('订单已发布'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('价格: ¥${_price.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            const Text('已通知附近的达人，请耐心等待。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('继续发单'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              router.push(ClientOrderDetailRoute(order: newOrder));
            },
            child: const Text('查看订单'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 地图层 (背景)
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
              
              if (_isSearching) RadarRipple(controller: _rippleController),
                
              const Center(child: Icon(Icons.person_pin_circle, size: 50, color: Colors.black87)),
            ],
          ),
        ),

        // 2. 顶部登出按钮
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
                child: _isSearching 
                  ? SearchingView(onStopSearch: _stopSearch)
                  : OrderFormPanel(
                      selectedServiceIndex: _selectedServiceIndex,
                      descController: _descController,
                      price: _price,
                      isAnalyzing: _isAnalyzing,
                      hasPhoto: _hasPhoto,
                      onServiceSelected: _onServiceSelected,
                      onAnalyze: _analyzeOrder,
                      onPriceChanged: (newPrice) => setState(() => _price = newPrice),
                      onPhotoToggle: () => setState(() => _hasPhoto = !_hasPhoto),
                      onSubmit: _startSearch,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
