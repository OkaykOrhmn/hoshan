import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/main.dart';

class FirebasApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    if (kDebugMode) {
      print('fCMToken: $fCMToken');
    }

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(Routes.main);
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
