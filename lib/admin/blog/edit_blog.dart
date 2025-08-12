import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditBanner extends StatefulWidget {
  const EditBanner({
    super.key,
    required this.data,
  });
  final QueryDocumentSnapshot data;

  @override
  State<EditBanner> createState() => _EditBannerState();
}

class _EditBannerState extends State<EditBanner> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  File? selectedImage;
  bool isUpload = false;

  @override
  void initState() {
    _messageController.text = widget.data.get('message');
    _positionController.text = widget.data.get('position').toString();

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Banner',
          style: TextStyle(color: Colors.black),
        ),
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

            // message
            TextFormField(
              controller: _messageController,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.data.get('image'),
                              ),
                            )),
                        height: 200,
                        width: double.infinity,
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
                      setState(() => isUpload = true);
                      //
                      FirebaseFirestore.instance
                          .collection('banners')
                          .doc(widget.data.id)
                          .update({
                        'message': _messageController.text.trim(),
                        'position': int.parse(_positionController.text.trim()),
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg: 'Update banner successfully');
                        setState(() => isUpload = false);
                        Navigator.pop(context);
                      });
                    } else {
                      String message = _messageController.text.trim();
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
                    : const Text('Edit Banner'),
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
    var uid = widget.data.id;
    //
    var ref = FirebaseStorage.instance.ref('banners').child('$uid.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      //
      FirebaseFirestore.instance.collection('banners').doc(uid).update({
        'message': message,
        'image': imageUrl,
        'position': position,
      }).then((value) {
        Fluttertoast.showToast(msg: 'Update banner successfully');
        Navigator.pop(context);
      });
    });
  }
}
