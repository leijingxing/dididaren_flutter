// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSessionList)
const chatSessionListProvider = ChatSessionListProvider._();

final class ChatSessionListProvider
    extends $NotifierProvider<ChatSessionList, List<ChatSession>> {
  const ChatSessionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSessionListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSessionListHash();

  @$internal
  @override
  ChatSessionList create() => ChatSessionList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatSession> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatSession>>(value),
    );
  }
}

String _$chatSessionListHash() => r'712179634fc8a331e8d95f2df36932ecf8d8e464';

abstract class _$ChatSessionList extends $Notifier<List<ChatSession>> {
  List<ChatSession> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<ChatSession>, List<ChatSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatSession>, List<ChatSession>>,
              List<ChatSession>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChatMessages)
const chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends $NotifierProvider<ChatMessages, List<Message>> {
  const ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatMessages create() => ChatMessages();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Message> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Message>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'2b82eea8c4216dcf1d863a7ecff68c2e0dea889a';

final class ChatMessagesFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatMessages,
          List<Message>,
          List<Message>,
          List<Message>,
          String
        > {
  const ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessagesProvider call(String sessionId) =>
      ChatMessagesProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

abstract class _$ChatMessages extends $Notifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  List<Message> build(String sessionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<List<Message>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Message>, List<Message>>,
              List<Message>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
