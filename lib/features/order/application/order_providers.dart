import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/order_repository.dart';
import '../domain/order_model.dart';

part 'order_providers.g.dart';

@riverpod
class OrderList extends _$OrderList {
  @override
  Stream<List<Order>> build() {
    final repo = ref.watch(orderRepositoryProvider);
    return repo.getOrdersStream();
  }
}
