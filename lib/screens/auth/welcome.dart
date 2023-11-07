import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:priyobanskhali/screens/auth/signup2.dart';

import '../../utils/repo.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image.asset(
          AppRepo.kAppLogo,
          height: 32,
        ),
      ),
      //
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Container(
              height: 300,
              margin: const EdgeInsets.only(bottom: 24),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppRepo.kWelcomeImage),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                const Text(AppRepo.kAlreadyAccText),
                const SizedBox(height: 4),

                //log in
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        //
                        Get.to(const Login());
                      },
                      child: const Text('Log in')),
                ),

                const SizedBox(height: 16),

                const Text(AppRepo.kNoAccountText),
                const SizedBox(height: 4),

                //create new account
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      //
                      Get.to(
                        const SignUp2(),
                        transition: Transition.zoom,
                      );
                    },
                    child: const Text(
                      AppRepo.kCreateAccountText,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
