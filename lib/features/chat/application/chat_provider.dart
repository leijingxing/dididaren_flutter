import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/message_model.dart';

part 'chat_provider.g.dart';

// Mock Data
final _initialSessions = [
  ChatSession(
    id: '1',
    otherUserId: 'user_employer_1',
    otherUserName: '张先生 (雇主)',
    otherUserAvatar: 'assets/avatars/user1.png',
    lastMessage: Message(
      id: 'm1',
      senderId: 'user_employer_1',
      content: '你好，请问大概什么时候能到？',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    unreadCount: 1,
  ),
  ChatSession(
    id: '2',
    otherUserId: 'user_worker_2',
    otherUserName: '李师傅 (达人)',
    otherUserAvatar: 'assets/avatars/user2.png',
    lastMessage: Message(
      id: 'm2',
      senderId: 'me',
      content: '好的，麻烦了。',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    unreadCount: 0,
  ),
];

final _initialMessages = {
  '1': [
    Message(
      id: 'm0',
      senderId: 'me',
      content: '我接了您的订单，大概15分钟后到。',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      id: 'm1',
      senderId: 'user_employer_1',
      content: '你好，请问大概什么时候能到？',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ],
  '2': [
    Message(
      id: 'm2_1',
      senderId: 'user_worker_2',
      content: '老板，活干完了，您验收一下。',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Message(
      id: 'm2',
      senderId: 'me',
      content: '好的，麻烦了。',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ],
};

// 1. Session List Provider
@Riverpod(keepAlive: true)
class ChatSessionList extends _$ChatSessionList {
  @override
  List<ChatSession> build() {
    return _initialSessions;
  }

  void updateLastMessage(String sessionId, Message message) {
    state = [
      for (final session in state)
        if (session.id == sessionId)
          ChatSession(
            id: session.id,
            otherUserId: session.otherUserId,
            otherUserName: session.otherUserName,
            otherUserAvatar: session.otherUserAvatar,
            lastMessage: message,
            unreadCount: 0, 
          )
        else
          session
    ];
  }
}

// 2. Message List Provider
@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  List<Message> build(String sessionId) {
    return _initialMessages[sessionId] ?? [];
  }

  void sendMessage(String content, MessageType type, {int? duration}) {
    final newMessage = Message(
      id: const Uuid().v4(),
      senderId: 'me', 
      content: content,
      type: type,
      timestamp: DateTime.now(),
      duration: duration,
    );

    state = [...state, newMessage];

    // Update Session List
    ref.read(chatSessionListProvider.notifier).updateLastMessage(sessionId, newMessage);
    
    // Mock Auto-Reply
    if (type == MessageType.text) {
      _mockReply();
    }
  }

  void _mockReply() async {
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real notifier, we should check if we are still active, but simpler for mock
    final reply = Message(
      id: const Uuid().v4(),
      senderId: 'other',
      content: '收到，我知道了。',
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
    
    state = [...state, reply];
    ref.read(chatSessionListProvider.notifier).updateLastMessage(sessionId, reply);
  }
}