import 'package:flutter/material.dart';
//import 'package:foca_app/functions_page/navigation_bar.dart';
import 'package:foca_app/pages/login/login.dart';
//import 'package:foca_app/notification/firebase_notification_handler.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOCA',
      home: Login(),
    );
  }
}

void main() => runApp(App());
