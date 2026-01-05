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
/// [ChatDetailPage]
class ChatDetailRoute extends PageRouteInfo<ChatDetailRouteArgs> {
  ChatDetailRoute({
    Key? key,
    required String sessionId,
    required String userName,
    List<PageRouteInfo>? children,
  }) : super(
         ChatDetailRoute.name,
         args: ChatDetailRouteArgs(
           key: key,
           sessionId: sessionId,
           userName: userName,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatDetailRouteArgs>();
      return ChatDetailPage(
        key: args.key,
        sessionId: args.sessionId,
        userName: args.userName,
      );
    },
  );
}

class ChatDetailRouteArgs {
  const ChatDetailRouteArgs({
    this.key,
    required this.sessionId,
    required this.userName,
  });

  final Key? key;

  final String sessionId;

  final String userName;

  @override
  String toString() {
    return 'ChatDetailRouteArgs{key: $key, sessionId: $sessionId, userName: $userName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatDetailRouteArgs) return false;
    return key == other.key &&
        sessionId == other.sessionId &&
        userName == other.userName;
  }

  @override
  int get hashCode => key.hashCode ^ sessionId.hashCode ^ userName.hashCode;
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
/// [DeepLinkOpenPage]
class DeepLinkOpenRoute extends PageRouteInfo<DeepLinkOpenRouteArgs> {
  DeepLinkOpenRoute({
    Key? key,
    required String token,
    required Uri sourceUri,
    List<PageRouteInfo>? children,
  }) : super(
         DeepLinkOpenRoute.name,
         args: DeepLinkOpenRouteArgs(
           key: key,
           token: token,
           sourceUri: sourceUri,
         ),
         initialChildren: children,
       );

  static const String name = 'DeepLinkOpenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeepLinkOpenRouteArgs>();
      return DeepLinkOpenPage(
        key: args.key,
        token: args.token,
        sourceUri: args.sourceUri,
      );
    },
  );
}

class DeepLinkOpenRouteArgs {
  const DeepLinkOpenRouteArgs({
    this.key,
    required this.token,
    required this.sourceUri,
  });

  final Key? key;

  final String token;

  final Uri sourceUri;

  @override
  String toString() {
    return 'DeepLinkOpenRouteArgs{key: $key, token: $token, sourceUri: $sourceUri}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DeepLinkOpenRouteArgs) return false;
    return key == other.key &&
        token == other.token &&
        sourceUri == other.sourceUri;
  }

  @override
  int get hashCode => key.hashCode ^ token.hashCode ^ sourceUri.hashCode;
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
/// [MessageListPage]
class MessageListRoute extends PageRouteInfo<void> {
  const MessageListRoute({List<PageRouteInfo>? children})
    : super(MessageListRoute.name, initialChildren: children);

  static const String name = 'MessageListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MessageListPage();
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

/// generated route for
/// [RoleSelectionPage]
class RoleSelectionRoute extends PageRouteInfo<void> {
  const RoleSelectionRoute({List<PageRouteInfo>? children})
    : super(RoleSelectionRoute.name, initialChildren: children);

  static const String name = 'RoleSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RoleSelectionPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [SignInPage]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInPage();
    },
  );
}
