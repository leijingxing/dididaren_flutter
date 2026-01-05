import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_router.dart';

@RoutePage()
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCodeSent = false;
  int _countdown = 60;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_phoneController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入11位手机号')),
      );
      return;
    }

    setState(() {
      _isCodeSent = true;
      _countdown = 60;
    });

    // Mock countdown
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isCodeSent || _countdown <= 0) return false;
      setState(() {
        _countdown--;
        if (_countdown == 0) {
          _isCodeSent = false;
        }
      });
      return _isCodeSent;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('验证码已发送: 1234'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _login() async {
    // 快速测试模式：跳过验证
    // if (_phoneController.text.length != 11) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('请输入正确的手机号')),
    //   );
    //   return;
    // }

    // if (_codeController.text != '1234') {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('验证码错误 (模拟验证码为 1234)')),
    //   );
    //   return;
    // }

    setState(() {
      _isLoading = true;
    });

    // Mock Network Delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    // Navigate to Role Selection
    context.router.replace(const RoleSelectionRoute());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Brand Header
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.flash_on_rounded,
                      size: 32,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '欢迎使用\n滴滴达人',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '专业·高效·安全的即时人力服务平台',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),

              // Phone Input
              Text(
                '手机号码',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: '请输入手机号',
                  hintStyle: TextStyle(color: colorScheme.outline),
                  prefixIcon:
                      Icon(Icons.phone_iphone_rounded, color: colorScheme.outline),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Code Input
              Text(
                '验证码',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2),
                      decoration: InputDecoration(
                        hintText: '4位验证码',
                        hintStyle: TextStyle(color: colorScheme.outline),
                        prefixIcon: Icon(Icons.shield_outlined,
                            color: colorScheme.outline),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: colorScheme.primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 56, // Matches input height roughly
                    child: FilledButton.tonal(
                      onPressed: (_isCodeSent || _phoneController.text.length != 11)
                          ? null
                          : _sendCode,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                      ),
                      child: Text(
                        _isCodeSent ? '${_countdown}s' : '获取验证码',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Login Button
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : const Text(
                          '登录 / 注册',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const Spacer(),
              
              // Footer
              Column(
                children: [
                  Text(
                    '登录即代表同意',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('《用户协议》', 
                          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                      Text('与', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('《隐私政策》',
                           style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
