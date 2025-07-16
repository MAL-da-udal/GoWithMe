import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/functions/open_url.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeUrlLauncher extends UrlLauncherPlatform {
  final bool shouldSucceed;
  FakeUrlLauncher({required this.shouldSucceed});

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    return shouldSucceed;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    UrlLauncherPlatform.instance = FakeUrlLauncher(shouldSucceed: true);
  });

  test('openUrl does not throw if launchUrl returns true', () async {
    await openUrl('https://example.com');
  });

  test('openUrl throws exception if launchUrl returns false', () async {
    UrlLauncherPlatform.instance = FakeUrlLauncher(shouldSucceed: false);
    expect(() => openUrl('https://example.com'), throwsException);
  });
}
 