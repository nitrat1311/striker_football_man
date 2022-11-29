import 'package:appsflyer_sdk/appsflyer_sdk.dart';

class AppFlyer {
  init() {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "Q9s6D2WryPVHqybDdBUfyT",
      appId: "com.gamewerfallers.strikerFootballman",
      showDebug: true,
    );
    AppsflyerSdk _appsflyerSdk = AppsflyerSdk(options);
    return _appsflyerSdk;
  }

  initiate() {
    AppFlyer().init().getAppsFlyerUID().then((AppsFlyerId) {
      AppFlyer().init().initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: true);
    });
    AppFlyer().init().onInstallConversionData((res) {
      print("res: " + res.toString());
    });
  }

  Future<bool?> logEvent(String eventName, Map? eventValues) async {
    bool? result;
    try {
      result = await AppFlyer().init().logEvent(eventName, eventValues);
    } on Exception catch (e) {}
    return null;
  }

  Future<bool?> logCUID() async {
    bool? result;

    try {
      result = AppFlyer().init().getAppsFlyerUID().then(
        (AppsFlyerId) async {
          bool? res;
          print('11111{$AppsFlyerId}');
          res =
              await AppFlyer().logEvent('af_login', {'Logged': '$AppsFlyerId'});
        },
      );
    } on Exception catch (e) {}
    return null;
  }
}
