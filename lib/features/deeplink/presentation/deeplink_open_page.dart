import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_router.dart';
import '../application/deeplink_provider.dart';
import '../domain/deeplink_payload.dart';

@RoutePage()
class DeepLinkOpenPage extends ConsumerStatefulWidget {
  final String token;
  final Uri sourceUri;

  const DeepLinkOpenPage({
    super.key,
    required this.token,
    required this.sourceUri,
  });

  @override
  ConsumerState<DeepLinkOpenPage> createState() => _DeepLinkOpenPageState();
}

class _DeepLinkOpenPageState extends ConsumerState<DeepLinkOpenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deepLinkPayloadProvider.notifier).setPayload(
            DeepLinkPayload(token: widget.token, sourceUri: widget.sourceUri),
          );
      context.router.replaceAll([const HomeRoute()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
