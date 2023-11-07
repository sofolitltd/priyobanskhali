import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/screens/dashboard.dart';
import '../../utils/repo.dart';

// 1st
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedUnion;

  bool _isObscure = true;
  bool _isLoading = false;

  XFile? _pickedImage;

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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [
            // signup
            Text(
              AppRepo.kCreateAccountText,
              style: Theme.of(context).textTheme.headline5!.copyWith(
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

            const SizedBox(height: 16),

            //
            //image pick
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: _pickedImage == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Center(
                                  child: Text('No image selected')))
                          // child: Image.asset(
                          //     'assets/images/pp_placeholder.png',
                          //     fit: BoxFit.cover))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  //
                  Positioned(
                    bottom: 0,
                    right: 16,
                    child: MaterialButton(
                      onPressed: () => _pickImage(),
                      shape: const CircleBorder(),
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.all(12),
                      minWidth: 24,
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                AppRepo.kNameText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //name
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                AppRepo.kMobileText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //mobile
            TextFormField(
              controller: _mobileController,
              validator: (value) {
                if (value == null) {
                  return 'Enter Mobile Number';
                } else if (value.length < 11 || value.length > 11) {
                  return 'Mobile Number at least 11 digits';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Mobile Number',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                AppRepo.kUnionText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //union
            ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                value: _selectedUnion,
                hint: const Text(AppRepo.kSelectYourUnionText),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(-4, 16, 8, 16),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedUnion = value;
                  });
                },
                // validator: (value) =>
                //     value == null ? kSelectYourUnionText : null,
                items: AppRepo.kUnionList.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

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
                      //
                      if (_globalKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        //
                        await createNewUser(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
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

  //pick image
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    ImageCropper imageCropper = ImageCropper();

    CroppedFile? croppedImage = await imageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
      compressQuality: 60,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'image Customization',
          toolbarColor: ThemeData().cardColor,
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        )
      ],
    );
    if (croppedImage == null) return;

    setState(() {
      _pickedImage = XFile(croppedImage.path);
    });
  }

  // user signup
  createNewUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => null);

      //
      var user = userCredential.user;
      // print(user);

      if (user != null) {
        // uid generate
        String idGenerator() {
          var uid = 0;
          var ref = FirebaseFirestore.instance.collection('categories');
          ref.snapshots().forEach(
            (element) {
              uid = (element.docs.length + 1);
              print(uid);
            },
          );
          return uid.toString();
          //
        }

        //
        if (_pickedImage == null) {
          print('login with out image');

          //
          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': idGenerator(),
            'name': _nameController.text.trim().toLowerCase(),
            'email': _emailController.text.trim(),
            'union': _selectedUnion ?? '',
            'mobile': _mobileController.text.trim(),
            'image': '',
            'address': {},
          });
        } else {
          //
          const filePath = 'users/';
          final destination = '$filePath/${user.uid}.jpg';

          var task = FirebaseStorage.instance
              .ref(destination)
              .putFile(File(_pickedImage!.path));
          setState(() {});

          if (task == null) return;

          final snapshot = await task.whenComplete(() {});
          var downloadedUrl = await snapshot.ref.getDownloadURL();
          // print('Download-Link: $downloadedUrl');
          //
          FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'uid': idGenerator(),
              'name': _nameController.text.trim().toLowerCase(),
              'email': _emailController.text.trim(),
              'union': _selectedUnion ?? '',
              'mobile': _mobileController.text.trim(),
              'image': downloadedUrl,
              'address': {},
            },
          );
        }

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
      print('${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }
}
