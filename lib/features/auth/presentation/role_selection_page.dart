import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_router.dart';
import '../application/auth_provider.dart';
import '../domain/user_role.dart';

@RoutePage()
class RoleSelectionPage extends ConsumerWidget {
  const RoleSelectionPage({super.key});

  void _onRoleSelected(BuildContext context, WidgetRef ref, UserRole role) {
    // Store role in Riverpod state
    ref.read(authProvider.notifier).setRole(role);
    
    // Navigate to Home
    context.router.replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.router.replace(const SignInRoute()),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  Text(
                    '选择您的身份',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '身份决定了您在平台看到的功能',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _RoleSelectionCard(
                      title: '我是雇主',
                      subtitle: '发单找人，搬运/跑腿/杂活\n精准匹配周边达人',
                      icon: Icons.person_search_rounded,
                      themeColor: colorScheme.primary,
                      onTap: () => _onRoleSelected(context, ref, UserRole.client),
                    ),
                    const SizedBox(height: 24),
                    _RoleSelectionCard(
                      title: '我是达人',
                      subtitle: '在线接单，赚取劳务报酬\n自由安排工作时间',
                      icon: Icons.engineering_rounded,
                      themeColor: colorScheme.tertiary,
                      onTap: () => _onRoleSelected(context, ref, UserRole.worker),
                    ),
                  ],
                ),
              ),
            ),
            
            // Help Footer
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: colorScheme.outline),
                  const SizedBox(width: 8),
                  Text(
                    '进入应用后，您可以在个人中心切换身份',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color themeColor;
  final VoidCallback onTap;

  const _RoleSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: themeColor.withValues(alpha: 0.1),
        highlightColor: themeColor.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: themeColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
