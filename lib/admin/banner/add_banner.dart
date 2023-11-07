import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  File? selectedImage;
  bool isUpload = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // position
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(
                hintText: 'Position',
                label: Text('Position'),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter position' : null,
            ),

            const SizedBox(height: 16),

            //
            TextFormField(
              controller: _nameController,
              minLines: 3,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Message',
                label: Text('Message'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => value!.isEmpty ? 'Enter message' : null,
            ),
            const SizedBox(height: 16),

            //
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                selectedImage == null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text('No image selected'),
                      )
                    : SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),

                //
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: FloatingActionButton(
                    onPressed: () async {
                      addImage();
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            //
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    if (selectedImage == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'No image selected');
                    } else {
                      String message = _nameController.text.trim();
                      int position = int.parse(_positionController.text.trim());

                      //
                      setState(() => isUpload = true);

                      //
                      await uploadImage(message: message, position: position);

                      //
                      setState(() => isUpload = false);
                    }
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Banner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //add image
  addImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  //upload image
  uploadImage({required String message, required int position}) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();

    //
    var ref = FirebaseStorage.instance.ref('banners').child('$uid.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      //
      FirebaseFirestore.instance.collection('banners').doc(uid).set({
        'message': message,
        'image': imageUrl,
        'position': position,
      }).then((value) {
        Fluttertoast.showToast(msg: 'Upload banner successfully');
        Navigator.pop(context);
      });
    });
  }
}
