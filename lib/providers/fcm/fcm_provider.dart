import 'package:firebase_messaging/firebase_messaging.dart' show RemoteMessage;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hansungunivnotinoti/pages/loadrequest_webview.dart';
import 'dart:async';

class FCMProvider with ChangeNotifier {
  static BuildContext? _context;

  static void setContext(BuildContext context) =>
      FCMProvider._context = context;

  /// when app is in the foreground
  static void onTapNotification(NotificationResponse? response) async {
    String? payload = response?.payload.toString();
    if (FCMProvider._context == null || payload == null) return;
    final _data = FCMProvider.convertPayload(payload);
    if (_data.containsKey('link')) {
      await Navigator.of(FCMProvider._context!).push(
        MaterialPageRoute(
          builder: (context) => LoadRequestWebView(
              url: _data['link']!), // TODO: context to FCMProvider._context!
        ),
      );
    }
  }

  static Map<String, String> convertPayload(String payload) {
    final String _payload = payload.substring(1, payload.length - 1);
    Map<String, String> _mapped = {"link": _payload.split(': ')[1]};
    return _mapped;
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {}
}
