import 'dart:collection';
import 'dart:developer';

import 'package:advertising_id/advertising_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_app_links/flutter_facebook_app_links.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:strikerFootballman/utils/apps_attribution.dart';
import 'package:strikerFootballman/utils/appsflier.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:strikerFootballman/utils/network.dart';

class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    initPlatformState2();
    initPlatformState();
  }

  bool isDevMode = false;
  String sendThrowWebView = '';
  bool isInternetOn = false;
  void handleSendTagsAbout() {
    print("Sending tags");
    OneSignal.shared.sendTag("lelvel", "about").then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  Future<bool> httpCall(url) async {
    if (await isWebViewPath(Uri.parse(url))) {
      AppState().sendThrowWebView = await loadAttribution2(url);
      return true;
    } else {
      return false;
    }
  }

  void removeSplashScreen() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        FlutterNativeSplash.remove();
      },
    );
  }
}

Future<void> initPlatformState2() async {
  bool developerMode = false;

  try {
    developerMode = await FlutterJailbreakDetection.developerMode;
  } on PlatformException {
    developerMode = true;
  }

  AppState().isDevMode = developerMode;
}

Future<void> initPlatformState() async {
  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  await OneSignal.shared.setAppId("6cee4131-fcda-4e86-a413-efd1cb01e2d0");
}

loadAttribution2(linkFromRemouteConfig) async {
  String deepLinkUrl;
  String? advertisingId;
  AppsAttribution appsFlyer = AppsAttribution();
  appsFlyer.init();
  var uuid = await AppFlyer().init().getAppsFlyerUID();
  LinkedHashMap<dynamic, dynamic> attribution =
      await appsFlyer.conversionData();

  try {
    advertisingId = await AdvertisingId.id(true);
  } on PlatformException {
    advertisingId = 'Failed to get platform version.';
  }
  deepLinkUrl = await FlutterFacebookAppLinks.initFBLinks();

  return '?hash=$uuid&gaid=$advertisingId&${attributionDataToUrlQueryString(attribution, ATTRIBUTION_DEFAULT_EXCLUDE)}&deeplink=$deepLinkUrl';
}
