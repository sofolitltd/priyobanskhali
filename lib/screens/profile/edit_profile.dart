import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/repo.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.data});

  final DocumentSnapshot data;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedUnion;

  bool _isLoading = false;

  XFile? _pickedImage;

  @override
  void initState() {
    _nameController.text = widget.data.get('name');
    _mobileController.text = widget.data.get('mobile').toString();
    if (widget.data.get('union') != '') {
      _selectedUnion = widget.data.get('union');
    }
    _emailController.text = widget.data.get('email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [
            //image pick
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //image
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
                              child: widget.data.get('image') == ''
                                  ? const Center(
                                      child: Text('No image selected'))
                                  : Image.network(widget.data.get('image'),
                                      fit: BoxFit.cover),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  // add
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

            // const SizedBox(height: 12),
            //
            // // title
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            //   child: Text(
            //     AppRepo.kEmailText,
            //     style: Theme.of(context).textTheme.titleSmall,
            //   ),
            // ),
            //
            // //email
            // TextFormField(
            //   controller: _emailController,
            //   keyboardType: TextInputType.emailAddress,
            //   decoration: const InputDecoration(
            //     hintText: AppRepo.kEmailHint,
            //     contentPadding:
            //         EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            //     border: OutlineInputBorder(),
            //     // suffixIcon: regExp.hasMatch(_emailController.text.trim())
            //     //     ? const Icon(Icons.check, color: Colors.green)
            //     //     : const Icon(Icons.check),
            //   ),
            //   validator: (val) {
            //     if (val!.isEmpty) {
            //       return 'Enter your email';
            //     } else if (!regExp.hasMatch(val)) {
            //       return 'Enter valid email';
            //     }
            //     return null;
            //   },
            // ),

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
                        var user = FirebaseAuth.instance.currentUser!;

                        //
                        if (_pickedImage == null) {
                          log('update profile image with out change image');

                          //
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'uid': widget.data.get('uid'),
                            'name': _nameController.text.trim().toLowerCase(),
                            // 'email': _emailController.text.trim(),
                            'union': _selectedUnion ?? '',
                            'mobile': _mobileController.text.trim(),
                            'image': widget.data.get('image'),
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
                          var downloadedUrl =
                              await snapshot.ref.getDownloadURL();
                          // print('Download-Link: $downloadedUrl');
                          //
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update(
                            {
                              'uid': widget.data.get('uid'),
                              'name': _nameController.text.trim().toLowerCase(),
                              // 'email': _emailController.text.trim(),
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
                        Fluttertoast.showToast(
                            msg: 'Profile update successfully');
                      }

                      //
                      Get.back();
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(AppRepo.kEditProfileText),
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
}
