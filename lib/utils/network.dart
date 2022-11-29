import 'package:http/http.dart' as http;
import 'package:strikerFootballman/app_state.dart';

Future<int> httpResponseCodeByUri(Uri url) async {
  var response = await http.get(url);
  return response.statusCode;
}

Future<bool> isConnectionToWebSiteAvailable(Uri targetNsDomain) async {
  try {
    await httpResponseCodeByUri(targetNsDomain);
  } catch (e) {
    return false;
  }
  return true;
}

Future<bool> isInternetConnectionAvailable() async {
  AppState().isInternetOn =
      await isConnectionToWebSiteAvailable(Uri.https('www.google.com'));
  return await isConnectionToWebSiteAvailable(Uri.https('www.google.com'));
}

Future<bool> isWebViewPath(Uri checkUrlFromRemoteConfig) async {
  return (await httpResponseCodeByUri(checkUrlFromRemoteConfig)) != 404;
}
