import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VoiceCallPage extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const VoiceCallPage({
    super.key,
    required this.userName,
    required this.avatarUrl,
  });

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  Timer? _timer;
  int _seconds = 0;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  String _status = '正在呼叫...';

  @override
  void initState() {
    super.initState();
    // Simulate connection after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _status = '通话中';
          _startTimer();
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF222831), // Dark background for calls
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            // User Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                      image: DecorationImage(
                        image: widget.avatarUrl.startsWith('http') 
                            ? NetworkImage(widget.avatarUrl) as ImageProvider
                            : AssetImage(widget.avatarUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {}, // Handle error
                      ),
                      color: Colors.grey[800],
                    ),
                    child: widget.avatarUrl.contains('assets') 
                        ? const Icon(Icons.person, size: 60, color: Colors.white54) 
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.userName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _seconds > 0 ? _formatDuration(_seconds) : _status,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            
            // Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              decoration: const BoxDecoration(
                color: Color(0xFF393E46),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CallButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: '静音',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _CallButton(
                    icon: Icons.call_end,
                    label: '挂断',
                    color: Colors.redAccent,
                    iconColor: Colors.white,
                    isBig: true,
                    onTap: () => context.router.back(),
                  ),
                  _CallButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    label: '免提',
                    isActive: _isSpeakerOn,
                    onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
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

class _CallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;
  final bool isActive;
  final bool isBig;

  const _CallButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.iconColor,
    this.isActive = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: isBig ? 72 : 56,
            height: isBig ? 72 : 56,
            decoration: BoxDecoration(
              color: color ?? (isActive ? Colors.white : Colors.white24),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isBig ? 32 : 28,
              color: iconColor ?? (isActive ? Colors.black : Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
