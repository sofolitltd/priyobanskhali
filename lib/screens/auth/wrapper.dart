import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priyobanskhali/screens/auth/welcome.dart';
import 'package:priyobanskhali/screens/dashboard.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          return const Welcome();
        }
      },
    );
  }
}
