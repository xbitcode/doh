import 'package:doh_api_client/doh_api_client_method_channel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:doh_api_client/doh_api_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _pluginWorking = "false";
  final _dohApiClientPlugin = DohApiClient();
  String _apiGetRequest = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String pluginWorking;
    String apiGetRequest;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _dohApiClientPlugin.getPlatformVersion() ??
          'Unknown platform version';
      pluginWorking = await _dohApiClientPlugin.checkPluginFunc() ?? "false";
      apiGetRequest = await _dohApiClientPlugin.get(
              url: "https://demo1236495.mockable.io/getRequest",
              headers: {
                "User-Agent":
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
              },
              dohProvider: DohProvider.CloudFlare) ??
          "Called by Failure";
    } catch (e) {
      print(e);
      platformVersion = 'Failed to get platform version.';
      pluginWorking = "false";
      apiGetRequest = "failure";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _pluginWorking = pluginWorking;
      _apiGetRequest = apiGetRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(
              'Running on: $_platformVersion\n $_pluginWorking\n $_apiGetRequest'),
        ),
      ),
    );
  }
}
