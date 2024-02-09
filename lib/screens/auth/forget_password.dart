import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/repo.dart';

// Forgot Password
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Forget password',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      //
      body: //email
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailField,
                validator: (val) {
                  if (val!.isEmpty) {
                    return AppRepo.kEnterYourEmail;
                  } else if (!regExp.hasMatch(val)) {
                    return AppRepo.kEnterValidEmail;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: AppRepo.kEmailHint,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            const SizedBox(height: 8),

            //notice
            Text(
              '* Check your mail box for reset mail. If mail not in mailbox, please check on spam folder.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),

            //
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailField.text.trim())
                              .then((value) {
                            //
                            Fluttertoast.showToast(
                                msg: 'Password reset email sent to your email');

                            setState(() => _isLoading = false);
                          });

                          //
                          if (!mounted) return;
                          Navigator.pop(context);

                          //
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('No user found for this email'),
                                ),
                              );

                            //
                            setState(() => _isLoading = false);
                          }

                          //
                          // Fluttertoast.showToast(msg: '${e.message}');
                          // setState(() => _isLoading = false);
                        }
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
