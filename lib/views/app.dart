// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/cadastro.dart';
import 'package:project/views/tela_login.dart';

class ChronosPointApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        routes: {
          "/login": (context) => LoginScreen(),
          "/new-account": (context) => RegisterScreen(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            return LoginScreen();
          },
        )
        // initialRoute: "/login",
        );
  }
}
