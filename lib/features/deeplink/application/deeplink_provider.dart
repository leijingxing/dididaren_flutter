import 'package:flutter_riverpod/legacy.dart';
import '../domain/deeplink_payload.dart';

final deepLinkPayloadProvider =
    StateNotifierProvider<DeepLinkPayloadNotifier, DeepLinkPayload?>(
  (ref) => DeepLinkPayloadNotifier(),
);

class DeepLinkPayloadNotifier extends StateNotifier<DeepLinkPayload?> {
  DeepLinkPayloadNotifier() : super(null);

  void setPayload(DeepLinkPayload payload) {
    state = payload;
  }

  void clear() {
    state = null;
  }
}
