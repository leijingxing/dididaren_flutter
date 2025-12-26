import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app_router.dart';
import '../../../../auth/application/auth_provider.dart';
import '../../../../order/application/order_providers.dart';

class StatusHeader extends ConsumerWidget {
  final bool isOnline;

  const StatusHeader({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 定义品牌色
    final onlineGradient = LinearGradient(
      colors: [Colors.blue.shade800, Colors.blue.shade600],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final offlineColor = Colors.grey.shade200;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 16, 24, 24),
      decoration: BoxDecoration(
        gradient: isOnline ? onlineGradient : null,
        color: isOnline ? null : offlineColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: isOnline ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部行：状态开关 + 退出按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 状态胶囊
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.black.withOpacity(0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isOnline,
                        onChanged: (val) => ref.read(isOnlineProvider.notifier).set(val),
                        activeColor: Colors.white,
                        activeTrackColor: Colors.greenAccent.shade400,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        isOnline ? '听单中' : '已休息',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isOnline ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 登出按钮
              IconButton(
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: isOnline ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                ),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.router.replace(const LoginRoute());
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 收入展示
          Text(
            '今日预估收入 (元)',
            style: TextStyle(
              fontSize: 14,
              color: isOnline ? Colors.blue.shade100 : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '128.50',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto', // 使用更现代的字体
                  color: isOnline ? Colors.white : Colors.grey.shade800,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.white.withOpacity(0.2) : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+12% 较昨日',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOnline ? Colors.white : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
