enum MessageType { text, image, audio }

class Message {
  final String id;
  final String senderId;
  final String content; // Text content or URL for image/audio
  final MessageType type;
  final DateTime timestamp;
  final int? duration; // For audio in seconds

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.duration,
  });
}

class ChatSession {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar; // URL or asset path
  final Message lastMessage;
  final int unreadCount;

  const ChatSession({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    this.unreadCount = 0,
  });
}
