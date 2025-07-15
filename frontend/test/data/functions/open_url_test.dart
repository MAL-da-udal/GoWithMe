import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/functions/open_url.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('openUrl throws exception for invalid url', () async {
    expect(() => openUrl('invalid-url'), throwsException);
  });
}