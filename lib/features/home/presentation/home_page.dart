import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_router.dart';
import '../../auth/application/auth_provider.dart';
import '../../auth/domain/user_role.dart';
import 'client_home_view.dart';
import 'worker_home_view.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(authProvider);

    if (userRole == null) {
      // 异常情况或未登录，返回登录页
      Future.microtask(() => context.router.replace(const LoginRoute()));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // 移除了 AppBar，让子视图自己控制顶部区域
      body: userRole == UserRole.client
          ? const ClientHomeView()
          : const WorkerHomeView(),
    );
  }
}