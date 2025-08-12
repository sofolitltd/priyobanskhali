import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '/notification/fcm_sender.dart';
import '../../models/blog_model.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  File? _pickedMobileImage;
  Uint8List webImage = Uint8List(8);
  bool isUpload = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Blog',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 1000 ? size.width * .2 : 16,
            vertical: 16,
          ),
          children: [
            // title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                label: Text('Title'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              keyboardType: TextInputType.text,
              validator: (value) => value!.isEmpty ? 'Enter title' : null,
            ),

            const SizedBox(height: 16),

            // cont
            TextFormField(
              controller: _contentController,
              minLines: 3,
              maxLines: 16,
              decoration: const InputDecoration(
                hintText: 'Content',
                label: Text('Content'),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => value!.isEmpty ? 'Enter content' : null,
            ),
            const SizedBox(height: 16),

            //
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                _pickedMobileImage == null
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
                        child: kIsWeb
                            ? Image.memory(
                                webImage,
                                fit: BoxFit.fitHeight,
                              )
                            : Image.file(
                                _pickedMobileImage!,
                                fit: BoxFit.fitHeight,
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
                    if (_pickedMobileImage == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'No image selected');
                    } else {
                      String title = _titleController.text.trim();
                      String content = _contentController.text.trim();

                      //
                      setState(() => isUpload = true);

                      //
                      await uploadBlog(content: content, title: title);

                      //
                      setState(() => isUpload = false);
                    }
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Blog'),
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
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (!kIsWeb) {
      if (image != null) {
        var selectedMobileImage = File(image.path);
        setState(() {
          _pickedMobileImage = selectedMobileImage;
        });
      }
    } else if (kIsWeb) {
      if (image != null) {
        var selectedWebImage = await image.readAsBytes();
        setState(() {
          webImage = selectedWebImage;
          _pickedMobileImage = File('');
        });
      }
    }
  }

  //upload image
  uploadBlog({required String content, required String title}) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();

    //
    var ref = FirebaseStorage.instance.ref('blog').child('$uid.jpg');
    var imageUrl = '';

    //
    if (kIsWeb) {
      await ref.putData(webImage);
      imageUrl = await ref.getDownloadURL();
    } else {
      await ref.putFile(_pickedMobileImage!);
      imageUrl = await ref.getDownloadURL();
    }

    BlogModel blog = BlogModel(
      blogId: uid,
      title: title,
      content: content,
      date: Timestamp.fromDate(DateTime.now()),
      image: imageUrl,
    );

    //
    await FirebaseFirestore.instance
        .collection('blog')
        .doc(uid)
        .set(blog.toJson())
        .then(
      (value) {
        Fluttertoast.showToast(msg: 'Upload blog successfully');
        Navigator.pop(context);
      },
    );

    //
    //fcm
    await FCMSender.sendNotification(
      topic: 'blog',
      title: title,
      body: content.characters.take(150).toString(),
      image: imageUrl,
    );
  }
}
