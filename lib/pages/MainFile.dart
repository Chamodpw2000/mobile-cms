import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobilecms/pages/Dashboard.dart';
import 'package:mobilecms/pages/Home.dart';
import 'package:mobilecms/pages/VerifiEmail.dart';

class MainFile extends StatelessWidget {
  const MainFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.emailVerified == false) {
            return const Emailverification();
          }
          return const Dashboard();
        } else {
          return const Home();
        }
      },
    ));
  }
}
