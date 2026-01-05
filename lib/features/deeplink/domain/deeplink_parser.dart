import 'deeplink_payload.dart';

class DeepLinkParser {
  static DeepLinkPayload? parseOpenPage(Uri uri) {
    if (!_isOpenPage(uri)) {
      return null;
    }

    final token = _parseToken(uri);
    if (token == null) {
      return null;
    }

    return DeepLinkPayload(token: token, sourceUri: uri);
  }

  static bool _isOpenPage(Uri uri) {
    if (uri.scheme != 'dididaren') {
      return false;
    }

    final hostMatches = uri.host == 'open' &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'page';

    final pathMatches = uri.host.isEmpty &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'open' &&
        uri.pathSegments[1] == 'page';

    return hostMatches || pathMatches;
  }

  static String? _parseToken(Uri uri) {
    final rawToken = uri.queryParameters['token'];
    if (rawToken == null) {
      return null;
    }

    var token = rawToken.trim();
    if (token.length >= 2) {
      final first = token[0];
      final last = token[token.length - 1];
      final isQuoted =
          (first == '\'' && last == '\'') || (first == '"' && last == '"');
      if (isQuoted) {
        token = token.substring(1, token.length - 1).trim();
      }
    }

    if (token.isEmpty) {
      return null;
    }

    return token;
  }
}
