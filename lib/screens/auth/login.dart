import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:priyobanskhali/screens/auth/signup2.dart';
import 'package:priyobanskhali/screens/dashboard.dart';

import '../../utils/repo.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

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
      body: Form(
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [
            // login
            Text(
              AppRepo.kLoginText,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            // login with
            Text(
              AppRepo.kLoginWith,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: MediaQuery.of(context).size.width * .25),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                AppRepo.kEmailText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.subtitle1,
              decoration: const InputDecoration(
                hintText: AppRepo.kEmailHint,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(),
                // suffixIcon: regExp.hasMatch(_emailController.text.trim())
                //     ? const Icon(Icons.check, color: Colors.green)
                //     : const Icon(Icons.check),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return AppRepo.kEnterYourEmail;
                } else if (!regExp.hasMatch(val)) {
                  return AppRepo.kEnterValidEmail;
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                AppRepo.kPasswordText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //password
            TextFormField(
              controller: _passwordController,
              style: Theme.of(context).textTheme.subtitle1,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: AppRepo.kPasswordHint,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _isObscure = !_isObscure);
                  },
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined,
                  ),
                ),
              ),
              obscureText: _isObscure,
              validator: (val) {
                if (val!.isEmpty) {
                  return AppRepo.kEnterYourPassword;
                } else if (val.length < 8) {
                  return AppRepo.kPasswordAtLeast;
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // forget
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(100, 32) // put the width and height you want
                    ),
                onPressed: () {
                  Get.to(const ForgetPassword());
                },
                child: const Text(AppRepo.kForgetText),
              ),
            ),

            const SizedBox(height: 8),

            //log in
            ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_globalKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          //
                          loginWithEmail(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Log in')),

            const SizedBox(height: 32),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppRepo.kNoAccountText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                // sign up
                InkWell(
                  onTap: () {
                    //
                    Get.to(const SignUp2());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: const Text(
                      AppRepo.kCreateAccountText,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
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

  // user login
  loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;

      if (user != null) {
        //
        // await FirebaseMessaging.instance.getToken().then(
        //   (token) async {
        //     await FirebaseFirestore.instance
        //         .collection('Users')
        //         .doc(user.uid)
        //         .update({'deviceToken': token});
        //   },
        // );

        //
        if (!mounted) return;
        Get.offAll(const Dashboard());

        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
        print('No user found');
        Fluttertoast.showToast(msg: 'login failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      print('login error: $e');
      if (e.code == 'user-not-found') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
      Fluttertoast.showToast(msg: '${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }
}
