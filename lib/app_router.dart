import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'features/auth/presentation/role_selection_page.dart';
import 'features/auth/presentation/sign_in_page.dart';
import 'features/chat/presentation/chat_detail_page.dart'; // Import
import 'features/chat/presentation/message_list_page.dart'; // Import
import 'features/deeplink/domain/deeplink_parser.dart';
import 'features/deeplink/presentation/deeplink_open_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/order/domain/order_model.dart';
import 'features/order/presentation/active_order_detail_page.dart';
import 'features/order/presentation/client_order_detail_page.dart';
import 'features/order/presentation/order_detail_page.dart';
import 'features/settings/presentation/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  DeepLinkBuilder get deepLinkBuilder => (deepLink) {
        final payload = DeepLinkParser.parseOpenPage(deepLink.uri);
        if (payload == null) {
          return deepLink;
        }
        return DeepLink.single(
          DeepLinkOpenRoute(token: payload.token, sourceUri: payload.sourceUri),
        );
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: RoleSelectionRoute.page),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: MessageListRoute.page, path: '/messages'), // Add
        AutoRoute(page: ChatDetailRoute.page, path: '/chat'), // Add
        AutoRoute(page: DeepLinkOpenRoute.page, path: '/open/page'),
        AutoRoute(page: OrderDetailRoute.page, path: '/order-detail'),
        AutoRoute(page: ActiveOrderDetailRoute.page, path: '/active-order-detail'),
        AutoRoute(page: ClientOrderDetailRoute.page, path: '/client-order-detail'),
      ];
}
