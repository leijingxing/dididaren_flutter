import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class VideoCallPage extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const VideoCallPage({
    super.key,
    required this.userName,
    required this.avatarUrl,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Timer? _timer;
  int _seconds = 0;
  bool _isMuted = false;
  bool _isCameraOff = false;
  String _status = '正在呼叫...';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // Simulate connection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _status = '通话中';
          _isConnected = true;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Remote Video Layer (Mock)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: _isConnected
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for remote video
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: widget.avatarUrl.startsWith('http')
                                  ? NetworkImage(widget.avatarUrl) as ImageProvider
                                  : AssetImage(widget.avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.userName,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      _status,
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
          ),

          // 2. Local Video Preview (Mock)
          if (_isConnected && !_isCameraOff)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Center(
                  child: Icon(Icons.videocam_off, color: Colors.white54),
                ),
              ),
            ),

          // 3. Controls Overlay
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  if (_isConnected)
                    Text(
                      _formatDuration(_seconds),
                      style: const TextStyle(color: Colors.white, fontSize: 16, shadows: [
                        Shadow(blurRadius: 4, color: Colors.black)
                      ]),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        isActive: _isMuted,
                        onTap: () => setState(() => _isMuted = !_isMuted),
                      ),
                      _ControlButton(
                        icon: Icons.call_end,
                        color: Colors.redAccent,
                        isBig: true,
                        onTap: () => context.router.back(),
                      ),
                      _ControlButton(
                        icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                        isActive: _isCameraOff,
                        onTap: () => setState(() => _isCameraOff = !_isCameraOff),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Back Button (Top Left)
          Positioned(
             top: MediaQuery.of(context).padding.top + 10,
             left: 10,
             child: IconButton(
                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                 onPressed: () => context.router.back(),
             ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isActive;
  final bool isBig;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.isActive = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          color: isActive ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
