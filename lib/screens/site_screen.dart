import 'dart:async';

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:strikerFootballman/app_state.dart';

import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:flutter/gestures.dart';

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});

  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  final controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<FirebaseRemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context,
            AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator()
              : WelcomeWidget(
                  remoteConfig: snapshot.requireData,
                  controller: controller,
                );
        },
      )),
    );
  }
}

class WelcomeWidget extends AnimatedWidget {
  const WelcomeWidget({
    super.key,
    required this.controller,
    required this.remoteConfig,
  }) : super(listenable: remoteConfig);
  final Completer<WebViewController> controller;
  final FirebaseRemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          controller.future.then(
              (value) async => {await (await controller.future).goBack()});
          return false;
        },
        child: SafeArea(
          child: Stack(
            children: [
              WebView(
                onWebViewCreated: (webViewController) {
                  controller.complete(webViewController);
                },
                gestureNavigationEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: Uri.decodeFull(
                    '${remoteConfig.getString('aboutUs')}${AppState().sendThrowWebView}'),
                zoomEnabled: false,
                gestureRecognizers: {
                  (Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer()))
                },
              ),
              GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) async {
                  if (details.primaryVelocity! > 0) {
                    await swipeBack(context);
                  } else if (details.primaryVelocity! < 0) {
                    await swipeForward(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width / 24,
                      height: double.infinity,
                    ),
                    Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width / 24,
                      height: double.infinity,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> swipeBack(BuildContext context) async {
    if (await (await controller.future).canGoBack()) {
      await (await controller.future).goBack();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No back history item')),
      );
    }
  }

  Future<void> swipeForward(BuildContext context) async {
    if (await (await controller.future).canGoForward()) {
      await (await controller.future).goForward();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No forward history item')),
      );
    }
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp();
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 5),
    minimumFetchInterval: Duration.zero,
  ));
  await FirebaseRemoteConfig.instance.fetchAndActivate();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  return remoteConfig;
}
