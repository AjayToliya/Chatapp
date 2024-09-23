import 'package:chatterbox/view/ChatPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'view/HomePage.dart';
import 'view/LoginPage.dart';
import 'view/SignUpPage.dart';
import 'view/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_Screen',
      routes: {
        '/': (context) => HomePage(),
        'Login': (context) => LoginPage(),
        'SignUp': (context) => SignUpPage(),
        'ChatApp': (context) => ChatPage(),
        'splash_Screen': (context) => SplashScreen(),
      },
    ),
  );
}
