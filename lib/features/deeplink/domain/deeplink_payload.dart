import 'package:flutter/foundation.dart';

@immutable
class DeepLinkPayload {
  final String token;
  final Uri sourceUri;

  const DeepLinkPayload({
    required this.token,
    required this.sourceUri,
  });
}
