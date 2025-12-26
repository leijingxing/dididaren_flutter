// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ActiveOrderDetailPage]
class ActiveOrderDetailRoute extends PageRouteInfo<ActiveOrderDetailRouteArgs> {
  ActiveOrderDetailRoute({
    Key? key,
    required String initialOrderId,
    required List<Order> activeOrders,
    List<PageRouteInfo>? children,
  }) : super(
         ActiveOrderDetailRoute.name,
         args: ActiveOrderDetailRouteArgs(
           key: key,
           initialOrderId: initialOrderId,
           activeOrders: activeOrders,
         ),
         initialChildren: children,
       );

  static const String name = 'ActiveOrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ActiveOrderDetailRouteArgs>();
      return ActiveOrderDetailPage(
        key: args.key,
        initialOrderId: args.initialOrderId,
        activeOrders: args.activeOrders,
      );
    },
  );
}

class ActiveOrderDetailRouteArgs {
  const ActiveOrderDetailRouteArgs({
    this.key,
    required this.initialOrderId,
    required this.activeOrders,
  });

  final Key? key;

  final String initialOrderId;

  final List<Order> activeOrders;

  @override
  String toString() {
    return 'ActiveOrderDetailRouteArgs{key: $key, initialOrderId: $initialOrderId, activeOrders: $activeOrders}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ActiveOrderDetailRouteArgs) return false;
    return key == other.key &&
        initialOrderId == other.initialOrderId &&
        const ListEquality<Order>().equals(activeOrders, other.activeOrders);
  }

  @override
  int get hashCode =>
      key.hashCode ^
      initialOrderId.hashCode ^
      const ListEquality<Order>().hash(activeOrders);
}

/// generated route for
/// [ClientOrderDetailPage]
class ClientOrderDetailRoute extends PageRouteInfo<ClientOrderDetailRouteArgs> {
  ClientOrderDetailRoute({
    Key? key,
    required Order order,
    List<PageRouteInfo>? children,
  }) : super(
         ClientOrderDetailRoute.name,
         args: ClientOrderDetailRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'ClientOrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientOrderDetailRouteArgs>();
      return ClientOrderDetailPage(key: args.key, order: args.order);
    },
  );
}

class ClientOrderDetailRouteArgs {
  const ClientOrderDetailRouteArgs({this.key, required this.order});

  final Key? key;

  final Order order;

  @override
  String toString() {
    return 'ClientOrderDetailRouteArgs{key: $key, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClientOrderDetailRouteArgs) return false;
    return key == other.key && order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ order.hashCode;
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    Key? key,
    required Order order,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailRoute.name,
         args: OrderDetailRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'OrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return OrderDetailPage(key: args.key, order: args.order);
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.order});

  final Key? key;

  final Order order;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key && order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ order.hashCode;
}
