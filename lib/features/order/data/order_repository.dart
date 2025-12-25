import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/order_model.dart';
import '../domain/order_status.dart';

part 'order_repository.g.dart';

class OrderRepository {
  final _ordersController = StreamController<List<Order>>.broadcast();
  final List<Order> _orders = [];

  OrderRepository() {
    // 初始化一些模拟数据
    _orders.addAll([
      Order(
        id: const Uuid().v4(),
        title: '搬运两箱矿泉水',
        description: '需要体力好的，没有电梯，6楼',
        price: 25.0,
        distance: '0.5km',
        startLocation: '罗森便利店(解放碑店)',
        endLocation: '时代豪苑A座',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Order(
        id: const Uuid().v4(),
        title: '帮忙排队买火锅底料',
        description: '大概需要排队1小时',
        price: 50.0,
        distance: '1.2km',
        startLocation: '佩姐老火锅',
        endLocation: '顺丰快递点',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Order(
        id: const Uuid().v4(),
        title: '搬家小件物品',
        description: '几个包裹，需要带绳子',
        price: 80.0,
        distance: '3.0km',
        startLocation: '洪崖洞',
        endLocation: '大剧院',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ]);
    
    // 初始推送
    _emit();
  }

  Stream<List<Order>> getOrdersStream() async* {
    yield List.unmodifiable(_orders);
    yield* _ordersController.stream;
  }

  void addOrder(Order order) {
    _orders.insert(0, order); // 新订单放前面
    _emit();
  }

  void updateOrderStatus(String id, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      _emit();
    }
  }

  void _emit() {
    _ordersController.add(List.unmodifiable(_orders));
  }
  
  void dispose() {
    _ordersController.close();
  }
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  final repo = OrderRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
}