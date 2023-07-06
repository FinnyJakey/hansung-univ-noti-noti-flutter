import 'package:cloud_functions/cloud_functions.dart';

// THIS IS FOR FIREBASE FUNCTION

FirebaseFunctions functions = FirebaseFunctions.instance;

Future<String> getVersionInfo() async {
  HttpsCallable callable = functions.httpsCallable('getVersionInfo');
  final results = await callable();
  return (results.data);
}

Future<bool> addKeywordToDB(String deviceToken, String keyword) async {
  HttpsCallable callable = functions.httpsCallable('addKeywordToDB');
  final results =
      await callable.call({"deviceToken": deviceToken, "keyword": keyword});
  return (results.data);
}

Future<bool> removeKeywordFromDB(String deviceToken, String keyword) async {
  HttpsCallable callable = functions.httpsCallable('removeKeywordFromDB');
  final results =
      await callable.call({"deviceToken": deviceToken, "keyword": keyword});
  return (results.data);
}

Future<bool> subscribeKeyword(String deviceToken, String keyword) async {
  HttpsCallable callable = functions.httpsCallable('subscribeKeyword');
  final results =
      await callable.call({"deviceToken": deviceToken, "keyword": keyword});
  return (results.data);
}

Future<bool> unsubscribeKeyword(String deviceToken, String keyword) async {
  HttpsCallable callable = functions.httpsCallable('unsubscribeKeyword');
  final results =
      await callable.call({"deviceToken": deviceToken, "keyword": keyword});
  return (results.data);
}

Future<String> getArriveServiceKey() async {
  HttpsCallable callable = functions.httpsCallable('getArriveServiceKey');
  final results = await callable();
  return (results.data);
}

Future<String> getLocationServiceKey() async {
  HttpsCallable callable = functions.httpsCallable('getLocationServiceKey');
  final results = await callable();
  return (results.data);
}

Future<void> sendMessage(String message) async {
  HttpsCallable callable = functions.httpsCallable('sendMessage');
  await callable.call({"message": message});
}
