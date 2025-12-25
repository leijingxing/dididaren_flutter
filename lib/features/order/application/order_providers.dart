import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/order_repository.dart';
import '../domain/order_model.dart';

part 'order_providers.g.dart';

// 使用 Code Generation 替代 StateProvider
@riverpod
class IsOnline extends _$IsOnline {
  @override
  bool build() => true;

  void set(bool value) {
    state = value;
  }
}

@riverpod
class OrderList extends _$OrderList {
  @override
  Stream<List<Order>> build() {
    final repo = ref.watch(orderRepositoryProvider);
    return repo.getOrdersStream();
  }
}