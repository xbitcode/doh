import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doh_api_client/doh_api_client_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDohApiClient platform = MethodChannelDohApiClient();
  const MethodChannel channel = MethodChannel('doh_api_client');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
