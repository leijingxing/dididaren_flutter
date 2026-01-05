import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app_router.dart';
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
    final offlineColor = Colors.grey.shade100;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 16),
      decoration: BoxDecoration(
        gradient: isOnline ? onlineGradient : null,
        color: isOnline ? null : offlineColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: isOnline ? Colors.blue.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status Switch + Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Capsule
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline ? Colors.black.withValues(alpha: 0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isOnline ? null : [
                     BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 28,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: isOnline,
                          onChanged: (val) => ref.read(isOnlineProvider.notifier).set(val),
                          activeThumbColor: Colors.white,
                          activeTrackColor: Colors.greenAccent.shade400,
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnline ? '听单中' : '已休息',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isOnline ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message Button
                  IconButton.filledTonal(
                    icon: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: isOnline ? Colors.white : colorScheme.onSurfaceVariant,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isOnline ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      context.router.push(const MessageListRoute());
                    },
                  ),
                  const SizedBox(width: 8),
                  // Settings Button
                  IconButton.filledTonal(
                    icon: Icon(
                      Icons.settings_rounded,
                      size: 20,
                      color: isOnline ? Colors.white : colorScheme.onSurfaceVariant,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isOnline ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      context.router.push(const SettingsRoute());
                    },
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Earnings Display - Compact
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '今日预估',
                style: TextStyle(
                  fontSize: 13,
                  color: isOnline ? Colors.blue.shade100 : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '128.50',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  color: isOnline ? Colors.white : Colors.grey.shade800,
                  letterSpacing: -0.5,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '元',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isOnline ? Colors.blue.shade100 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}