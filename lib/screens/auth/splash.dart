import 'dart:async';

import 'package:flutter/material.dart';
import 'package:priyobanskhali/screens/auth/wrapper.dart';

import '/utils/repo.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    //
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WrapperScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            //
            Image.asset(
              AppRepo.kAppLogo,
              width: 150,
            ),

            const Spacer(flex: 2),
            //
            const SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(strokeWidth: 2)),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
