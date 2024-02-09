import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/repo.dart';
import '../dashboard.dart';

class Signup1 extends StatefulWidget {
  const Signup1({
    super.key,
    required this.name,
    required this.mobile,
    required this.union,
    required this.image,
  });

  final String name;
  final String mobile;
  final String union;
  final XFile? image;

  @override
  State<Signup1> createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;
  var userId = 0;

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  //
  getUserID() async {
    var ref = FirebaseFirestore.instance.collection('users');
    await ref.snapshots().forEach(
      (element) {
        userId = (element.docs.length + 1000);
        // setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log(userId.toString());

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
            // signup
            Text(
              AppRepo.kCreateAccountText,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            // create acc
            Text(
              AppRepo.kCreateWith,
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
                  return 'Enter your email';
                } else if (!regExp.hasMatch(val)) {
                  return 'Enter valid email';
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
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                hintText: AppRepo.kPasswordHint,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(_isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined)),
              ),
              obscureText: _isObscure,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter your password';
                } else if (val.length < 8) {
                  return 'Password at least 8 character';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // notice
            Text(
              '* Please remember this email and password for further login.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),

            // signup
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // //
                      if (_globalKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        //
                        await createNewUser(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          userId: userId.toString(),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(AppRepo.kSignupText),
            ),
          ],
        ),
      ),
    );
  }

  // user signup
  createNewUser({
    required String email,
    required String password,
    required String userId,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;
      if (user != null) {
        if (widget.image == null) {
          //
          log('login without => image');
          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': userId.toString(),
            'name': widget.name,
            'email': email,
            'mobile': widget.mobile,
            'union': widget.union,
            'image': '',
            'address': {},
          });
        } else {
          //
          log('login with => image');
          final destination = 'users/${user.uid}.jpg';

          var task = FirebaseStorage.instance
              .ref(destination)
              .putFile(File(widget.image!.path));
          setState(() {});

          if (task == null) return;

          final snapshot = await task.whenComplete(() {});
          var downloadedUrl = await snapshot.ref.getDownloadURL();
          // print('Download-Link: $downloadedUrl');
          //
          FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'uid': userId.toString(),
              'name': widget.name,
              'email': email,
              'mobile': widget.mobile,
              'union': widget.union,
              'image': downloadedUrl,
              'address': {},
            },
          );
        }

        //

        //
        setState(() => _isLoading = false);

        //
        if (!mounted) return null;
        Get.offAll(const Dashboard());
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
        setState(() => _isLoading = false);
      }

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() => _isLoading = false);
        //
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign up Error'),
            content: const Text('The account already exists for that email.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          ),
        );
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
      Fluttertoast.showToast(msg: '${e.message}');
      log('${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      log(e.toString());
    }
  }
}

//todo google sign in
// signup
// OutlinedButton(
// onPressed: _isGoogleLoading
// ? null
// : () async {
// bool result = await DataConnectionChecker().hasConnection;
// if (result == true) {
// setState(() => _isGoogleLoading = true);
// } else {
// Fluttertoast.showToast(msg: 'No internet Connection!');
// }
//
// //
// },
// child: _isGoogleLoading
// ? const CircularProgressIndicator()
// : Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// //logo
// Image.asset(
// AppRepo.kGoogleLogo,
// height: 32,
// width: 32,
// ),
//
// const SizedBox(width: 8),
// //
// const Text(
// 'Continue with google',
// style: TextStyle(color: Colors.black),
// ),
// ],
// ),
// ),
