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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
      decoration: BoxDecoration(
        color: isOnline ? colorScheme.primaryContainer : Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日收入 (元)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOnline ? colorScheme.onPrimaryContainer.withOpacity(0.7) : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '128.50',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Monospace',
                          color: isOnline ? colorScheme.onPrimaryContainer : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                   Column(
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: isOnline,
                          onChanged: (val) => ref.read(isOnlineProvider.notifier).set(val),
                          activeColor: colorScheme.primary,
                        ),
                      ),
                      Text(
                        isOnline ? '听单中' : '已休息',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOnline ? Colors.green[700] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.logout, color: isOnline ? colorScheme.onPrimaryContainer : Colors.grey[600]),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.router.replace(const LoginRoute());
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
