import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:priyobanskhali/screens/auth/signup2.dart';

import '../../utils/repo.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: const EdgeInsets.all(16),
      titlePadding: EdgeInsets.only(top: 16, left: 16, right: 8),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Image.asset(
            AppRepo.kAppLogo,
            height: 32,
          ),

          //
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      //

      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // login
                Text(
                  AppRepo.kLoginText,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.start,
                ),

                // login with
                Text(
                  AppRepo.kLoginWith,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 32),

                // title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    AppRepo.kEmailText,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.black54),
                  ),
                ),

                //email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: AppRepo.kEmailHint,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),

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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    AppRepo.kPasswordText,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.black54),
                  ),
                ),

                //password
                TextFormField(
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.titleMedium,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: AppRepo.kPasswordHint,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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

                // const SizedBox(height: 8),

                // forget
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            100, 32) // put the width and height you want
                        ),
                    onPressed: () {
                      Get.to(const ForgetPassword());
                    },
                    child: const Text(AppRepo.kForgetText),
                  ),
                ),

                // const SizedBox(height: 8),

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

                const SizedBox(height: 24),

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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: const Text(
                          AppRepo.kCreateAccountText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
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
        await FirebaseMessaging.instance.getToken().then(
          (token) async {
            await FirebaseFirestore.instance
                .collection('tokens')
                .doc(user.uid)
                .set({'deviceToken': token});
          },
        );

        //
        if (!mounted) return;
        // Get.offAll(const Dashboard());
        Get.back();

        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
        log('No user found');
        Fluttertoast.showToast(msg: 'login failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      log('login error: $e');
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
      log(e.toString());
    }
  }
}
