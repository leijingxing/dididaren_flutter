import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize the router
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Dididaren',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // 使用商务蓝作为种子色，生成专业、稳重的配色方案
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052D9), // 经典的专业商务蓝
          brightness: Brightness.light,
          primary: const Color(0xFF0052D9),
        ),
        // 全局卡片样式微调
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        // 全局输入框样式微调
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        // 统一按钮圆角
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      routerConfig: appRouter.config(
        deepLinkBuilder: appRouter.deepLinkBuilder,
      ),
    );
  }
}