// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsOnline)
const isOnlineProvider = IsOnlineProvider._();

final class IsOnlineProvider extends $NotifierProvider<IsOnline, bool> {
  const IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  IsOnline create() => IsOnline();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOnlineHash() => r'9bf9890c18bb53660256da2e0785ca1e9b698999';

abstract class _$IsOnline extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

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
