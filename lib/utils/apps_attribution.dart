import 'dart:collection';
import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppsAttribution {
  void init() {
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
  }

  Future<LinkedHashMap<dynamic, dynamic>> conversionData() async {
    Completer c = Completer();
    void callback(dynamic data) {
      c.complete(data);
    }

    _appsflyerSdk.onInstallConversionData(callback);
    return await c.future;
  }

  AppsflyerSdk instance() {
    return _appsflyerSdk;
  }

  late AppsflyerSdk _appsflyerSdk;
  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: "Q9s6D2WryPVHqybDdBUfyT",
    appId: "com.gamewerfallers.strikerFootballman",
    showDebug: true,
  );
}

const List ATTRIBUTION_DEFAULT_EXCLUDE = [
  "af_message",
  "cost_cents_USD",
  "install_time"
];

String attributionDataToUrlQueryString(
    LinkedHashMap<dynamic, dynamic> attribution, List unusedKeys) {
  String query = "?";

  append(key, value) {
    if (!unusedKeys.contains(key)) {
      query += "$key=$value&";
    }
  }

  attribution.forEach((key, value) {
    if (key == "payload") {
      (value as LinkedHashMap<dynamic, dynamic>).forEach((key, value) {
        append(key, value);
      });
    } else {
      append(key, value);
    }
  });

  query += "tch=flutter";
  return query;
}
