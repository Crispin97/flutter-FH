import 'package:flutter/material.dart';

import 'package:push_app/pages/home_page.dart';
import 'package:push_app/pages/mensaje_page.dart';
import 'package:push_app/providers/push_notifications_provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    final pushProvider = new PushClassNotifications();
    pushProvider.initNotifications();

    pushProvider.mensajesStream.listen((event) {
      // print('Argumento desde main: $event');
      // Navigator.pushNamed(context, 'mensaje');
      navigatorKey.currentState.pushNamed('mensaje', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'mensaje': (BuildContext context) => MensajePage(),
      },
    );
  }
}