import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/order/domain/order_model.dart';
import 'features/order/presentation/active_order_detail_page.dart';
import 'features/order/presentation/client_order_detail_page.dart';
import 'features/order/presentation/order_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: OrderDetailRoute.page, path: '/order-detail'),
        AutoRoute(page: ActiveOrderDetailRoute.page, path: '/active-order-detail'),
        AutoRoute(page: ClientOrderDetailRoute.page, path: '/client-order-detail'),
      ];
}
