import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../screens/chat_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (usersnapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
