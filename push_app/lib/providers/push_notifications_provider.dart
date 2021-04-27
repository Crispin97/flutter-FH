import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushClassNotifications{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajesStreamController.stream;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifications() async{

    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();

    print('=== FMC Token ======');
    print(token);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print('===== Message ========');
    final argumento = message['data']['comida'] ?? 'no-data';
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('===== onLaunch ========');
    // print('message: $message');
    // print('argumento: $argumento');
    final argumento = message['data']['comida'] ?? 'no-data';
    _mensajesStreamController.sink.add(argumento);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print('===== onResume ========');
    final argumento = message['data']['comida'] ?? 'no-data';
    _mensajesStreamController.sink.add(argumento);
  }

  dispose(){
    _mensajesStreamController?.close();
  }
}