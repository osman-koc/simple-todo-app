import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simpletodo/screens/home.dart';
import 'package:simpletodo/screens/loading.dart';
import 'package:simpletodo/screens/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const LoginPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return checkUserAlreadyLogin() ? const HomePage() : const LoginPage();
        }

        return const LoadingScreen();
      },
    );
  }
}

bool checkUserAlreadyLogin() {
  try {
    var auth = FirebaseAuth.instance;
    var isLogin = auth.currentUser != null && !auth.currentUser!.isAnonymous;
    return isLogin;
  } catch (e) {
    if (kDebugMode) {
      print('Check login status failed!');
    }
    return false;
  }
}
