import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:strikerFootballman/app_state.dart';
import 'package:strikerFootballman/screens/game_menu.dart';
import 'package:strikerFootballman/screens/site_screen.dart';
import 'dart:async';

import 'package:strikerFootballman/utils/appsflier.dart';

class WhereToGoWidget extends StatelessWidget {
  const WhereToGoWidget({super.key});

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
              : EnterMenu(remoteConfig: snapshot.requireData);
        },
      )),
    );
  }
}

class EnterMenu extends AnimatedWidget {
  const EnterMenu({
    super.key,
    required this.remoteConfig,
  }) : super(listenable: remoteConfig);

  final FirebaseRemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    if (remoteConfig.getString('aboutUs') == '' ||
        remoteConfig.getString('test') == '') {
      AppState().isDevMode = true;
    }

    if (AppState().isDevMode || kDebugMode) {
      AppFlyer().logEvent('af_login', {'Logged': 'wentToSite'});
      return const GameMenu();
    }
    final String url = remoteConfig.getString('test');
    return FutureBuilder<bool>(
      future: AppState().httpCall(url),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        AppState().removeSplashScreen();
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else {
          final bool isWebViewPath = snapshot.requireData;
          if (!isWebViewPath) {
            return const GameMenu();
          } else {
            AppFlyer().logEvent('af_login', {'Logged': 'wentToSite'});
            AppState().handleSendTagsAbout();
            return Stack(children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl:
                    Uri.decodeFull('$url${AppState().sendThrowWebView}'),
              ),
              const SiteScreen()
            ]);
          }
        }
      },
    );
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
