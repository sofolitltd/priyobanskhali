import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:priyobanskhali/screens/auth/signup1.dart';

import '../../utils/repo.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? _selectedUnion;
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
              'User information',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            // create acc
            Text(
              'enter your information',
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

            const SizedBox(height: 8),

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

            const SizedBox(height: 8),

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
                onChanged: (value) {
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

            const SizedBox(height: 24),

            // signup
            ElevatedButton(
              onPressed: () async {
                //
                if (_globalKey.currentState!.validate()) {
                  //
                  Get.to(
                    Signup1(
                      name: _nameController.text.trim(),
                      mobile: _mobileController.text,
                      union: _selectedUnion ?? '',
                      image: _pickedImage,
                    ),
                  );
                }
              },
              child: const Text('Next'),
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
