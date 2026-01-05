import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/chat_provider.dart';
import '../domain/message_model.dart';

@RoutePage()
class ChatDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String userName;

  const ChatDetailPage({
    super.key,
    required this.sessionId,
    required this.userName,
  });

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isVoiceMode = false;
  bool _isRecording = false; // Mock recording state

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    
    ref.read(chatMessagesProvider(widget.sessionId).notifier).sendMessage(
          _textController.text.trim(),
          MessageType.text,
        );
    
    _textController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _sendImage() {
    // Mock Image Send
    ref.read(chatMessagesProvider(widget.sessionId).notifier).sendMessage(
          'https://via.placeholder.com/150', // Mock URL
          MessageType.image,
        );
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }
  
  void _sendMockVoice() {
      // Mock Voice Send
      ref.read(chatMessagesProvider(widget.sessionId).notifier).sendMessage(
            '',
            MessageType.audio,
            duration: 5,
          );
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider(widget.sessionId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest, // Slightly grey bg for chat
      appBar: AppBar(
        title: Text(widget.userName),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
            IconButton(icon: const Icon(Icons.more_horiz), onPressed: (){}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == 'me';
                return _MessageBubble(message: message, isMe: isMe);
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Voice Switch Button
                  IconButton(
                    icon: Icon(
                      _isVoiceMode ? Icons.keyboard_alt_outlined : Icons.mic_none_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _isVoiceMode = !_isVoiceMode;
                      });
                    },
                  ),
                  
                  Expanded(
                    child: _isVoiceMode 
                    ? GestureDetector(
                        onLongPressStart: (_) {
                            setState(() => _isRecording = true);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('正在录音... (松手发送)'), duration: Duration(seconds: 60),));
                        },
                        onLongPressEnd: (_) {
                             setState(() => _isRecording = false);
                             ScaffoldMessenger.of(context).clearSnackBars();
                             _sendMockVoice();
                        },
                        child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                                color: _isRecording ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                _isRecording ? '松开 发送' : '按住 说话',
                                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                            ),
                        ),
                    )
                    : TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '发送消息...',
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHigh,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  
                  // More Actions / Send Button
                  if (!_isVoiceMode)
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded, size: 28, color: colorScheme.onSurfaceVariant),
                    onPressed: () {
                         showModalBottomSheet(context: context, builder: (ctx) {
                             return Container(
                                 height: 160,
                                 padding: const EdgeInsets.all(24),
                                 child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                     children: [
                                         _ActionButton(icon: Icons.image, label: '图片', onTap: (){ Navigator.pop(ctx); _sendImage(); }),
                                         _ActionButton(icon: Icons.camera_alt, label: '拍摄', onTap: (){Navigator.pop(ctx);}),
                                         _ActionButton(icon: Icons.location_on, label: '位置', onTap: (){Navigator.pop(ctx);}),
                                     ],
                                 ),
                             );
                         });
                    },
                  ),

                  if (!_isVoiceMode)
                  IconButton(
                      icon: Icon(Icons.send_rounded, color: colorScheme.primary),
                      onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
    final IconData icon;
    final String label;
    final VoidCallback onTap;
    
    const _ActionButton({required this.icon, required this.label, required this.onTap});
    
    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, size: 32, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
            ),
        );
    }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: message.type == MessageType.image 
            ? const EdgeInsets.all(0) 
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
              if (!isMe)
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: _buildContent(theme, isMe),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isMe ? theme.colorScheme.onPrimary : Colors.black87,
          ),
        );
      case MessageType.image:
        return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
                height: 150,
                width: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50, color: Colors.white),
            ),
        );
      case MessageType.audio:
         return Row(
             mainAxisSize: MainAxisSize.min,
             children: [
                 Icon(Icons.graphic_eq, color: isMe ? theme.colorScheme.onPrimary : Colors.black87),
                 const SizedBox(width: 8),
                 Text('${message.duration ?? 5}"', style: TextStyle(color: isMe ? theme.colorScheme.onPrimary : Colors.black87)),
             ],
         );
    }
  }
}
