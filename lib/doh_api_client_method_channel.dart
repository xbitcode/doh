import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'doh_api_client_platform_interface.dart';

/// An implementation of [DohApiClientPlatform] that uses method channels.
class MethodChannelDohApiClient extends DohApiClientPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('doh_api_client');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> checkPluginFunc() async {
    final isWorking =
        await methodChannel.invokeMethod<String>('test-plugin-functionality');
    return isWorking;
  }

  @override
  Future<String?> get(
      String url, Map<String, dynamic> headers, DohProvider dohProvider) async {
    final result = await methodChannel.invokeMethod('makeGetRequest', {
      'url': url,
      'headers': headers,
      "dohProvider": dohProvider.toString()
    });

    return result;
  }
}

enum DohProvider {
  CloudFlare,
  Google,
  AdGuard,
  Quad9,
  AliDNS,
  DNSPod,
  threeSixty,
  Quad101,
  Mullvad,
  ControlD,
  Najalla,
  SheCan
}
