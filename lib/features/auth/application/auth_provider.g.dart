// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
const authProvider = AuthProvider._();

final class AuthProvider extends $NotifierProvider<Auth, UserRole?> {
  const AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRole? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRole?>(value),
    );
  }
}

String _$authHash() => r'27333a18ed423b2b4a2f014cf35a8dbd62e4999d';

abstract class _$Auth extends $Notifier<UserRole?> {
  UserRole? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserRole?, UserRole?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserRole?, UserRole?>,
              UserRole?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
