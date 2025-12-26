import 'package:flutter/material.dart';

/// 正在呼叫达人的搜索界面
class SearchingView extends StatelessWidget {
  final VoidCallback onStopSearch;

  const SearchingView({super.key, required this.onStopSearch});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '正在呼叫附近的达人...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'AI 已为您匹配 5 位最合适的达人',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: onStopSearch,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            side: const BorderSide(color: Colors.grey),
          ),
          child: const Text('取消呼叫', style: TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}
