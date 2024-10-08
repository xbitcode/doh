import 'package:flutter_test/flutter_test.dart';
import 'package:doh_api_client/doh_api_client.dart';
import 'package:doh_api_client/doh_api_client_platform_interface.dart';
import 'package:doh_api_client/doh_api_client_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDohApiClientPlatform
    with MockPlatformInterfaceMixin
    implements DohApiClientPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> checkPluginFunc() => Future.value("true");

  @override
  Future<String?> get(String url, Map<String, dynamic>? headers, DohProvider dohProvider) =>
      Future.value("");
}

void main() {
  final DohApiClientPlatform initialPlatform = DohApiClientPlatform.instance;

  test('$MethodChannelDohApiClient is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDohApiClient>());
  });

  test('getPlatformVersion', () async {
    DohApiClient dohApiClientPlugin = DohApiClient();
    MockDohApiClientPlatform fakePlatform = MockDohApiClientPlatform();
    DohApiClientPlatform.instance = fakePlatform;

    expect(await dohApiClientPlugin.getPlatformVersion(), '42');
  });
}
