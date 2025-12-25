// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderList)
const orderListProvider = OrderListProvider._();

final class OrderListProvider
    extends $StreamNotifierProvider<OrderList, List<Order>> {
  const OrderListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderListHash();

  @$internal
  @override
  OrderList create() => OrderList();
}

String _$orderListHash() => r'08967b7a97ffb59dfa9cd711e2572f0b88460b6f';

abstract class _$OrderList extends $StreamNotifier<List<Order>> {
  Stream<List<Order>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Order>>, List<Order>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Order>>, List<Order>>,
              AsyncValue<List<Order>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
