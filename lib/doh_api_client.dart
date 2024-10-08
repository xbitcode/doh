import 'package:doh_api_client/doh_api_client_method_channel.dart';

import 'doh_api_client_platform_interface.dart';

class DohApiClient {
  Future<String?> getPlatformVersion() {
    return DohApiClientPlatform.instance.getPlatformVersion();
  }

  Future<String?> checkPluginFunc() {
    return DohApiClientPlatform.instance.checkPluginFunc();
  }

  Future<String?> get({required String url, Map<String, dynamic>? headers, DohProvider? dohProvider}) {
    return DohApiClientPlatform.instance.get(url, headers ?? {}, dohProvider ?? DohProvider.CloudFlare);
  }
}
