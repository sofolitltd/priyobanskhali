import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditEmergencyCategoryAdmin extends StatefulWidget {
  const EditEmergencyCategoryAdmin({Key? key, required this.data})
      : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  State<EditEmergencyCategoryAdmin> createState() =>
      _EditEmergencyCategoryAdminState();
}

class _EditEmergencyCategoryAdminState
    extends State<EditEmergencyCategoryAdmin> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  XFile? selectedImage;
  UploadTask? task;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.data.get('category');
    _idController.text = widget.data.get('id').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Category',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          //
          Form(
            key: _formState,
            child: ListView(
              shrinkWrap: true,
              children: [
                //image
                InkWell(
                  onTap: () => pickImage(),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    padding: const EdgeInsets.all(6),
                    color: Colors.grey,
                    strokeWidth: 2,
                    dashPattern: const [5],
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue.shade50,
                      ),
                      alignment: Alignment.center,
                      child: selectedImage == null
                          ? Image.network(
                              widget.data.get('image'),
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(selectedImage!.path),
                              // fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                //id
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                    labelText: 'Id',
                    hintText: '1',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter id" : null,
                ),
                const SizedBox(height: 16),
                // title
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                    hintText: 'Hospital',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter category" : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //
          ElevatedButton.icon(
              icon: _isLoading
                  ? Container()
                  : const Icon(Icons.cloud_upload_outlined),
              onPressed: _isLoading
                  ? null
                  : () async {
                      String id = widget.data.id;

                      if (_formState.currentState!.validate()) {
                        if (selectedImage == null) {
                          setState(() {
                            _isLoading = true;
                          });
                          // edit category when image [not change]
                          await FirebaseFirestore.instance
                              .collection('emergency_categories')
                              .doc(id)
                              .update({
                            'id': int.parse(_idController.text.trim()),
                            'category': _titleController.text.trim(),
                            'image': widget.data.get('image'),
                          });

                          // edit category items
                          await FirebaseFirestore.instance
                              .collection('emergency')
                              .where('category',
                                  isEqualTo: widget.data.get('category'))
                              .get()
                              .then((value) {
                            for (var snap in value.docs) {
                              snap.reference.update({
                                'category': _titleController.text.trim(),
                              });
                            }
                          });

                          //
                          setState(() {
                            _isLoading = false;
                          });
                          if (!mounted) return;
                          Navigator.pop(context);
                        } else {
                          // fire image
                          await updateImageToFireStore(
                            name: id,
                          );
                        }
                      }
                    },
              label: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update')),
        ],
      ),
    );
  }

// upload file to fire store
  updateImageToFireStore({required name}) async {
    // fire storage
    final filePath = 'emergency/$name.jpg';

    task = FirebaseStorage.instance
        .ref(filePath)
        .putFile(File(selectedImage!.path));
    //
    setState(() {});

    if (task == null) return;
    progressDialog(context, task!);

    //
    final snapshot = await task!.whenComplete(() {});
    var imageUrl = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $downloadedUrl');

    //
    await FirebaseFirestore.instance
        .collection('emergency_categories')
        .doc(name)
        .update({
      'id': int.parse(_idController.text.trim()),
      'category': _titleController.text.trim(),
      'image': imageUrl,
    });

    // edit category items
    await FirebaseFirestore.instance
        .collection('emergency')
        .where('category', isEqualTo: widget.data.get('category'))
        .get()
        .then((value) {
      for (var snap in value.docs) {
        snap.reference.update({
          'category': _titleController.text.trim(),
        });
      }
    });

    //
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
  }

  //
  progressDialog(BuildContext context, UploadTask task) {
    FocusManager.instance.primaryFocus!.unfocus();

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(12),
              title: Stack(
                alignment: Alignment.centerRight,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Uploading File',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      child: const Icon(
                        Icons.close_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.all(12),
              content: StreamBuilder<TaskSnapshot>(
                  stream: task.snapshotEvents,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!;
                      final progress = snap.bytesTransferred / snap.totalBytes;
                      final percentage = (progress * 100).toStringAsFixed(0);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: LinearProgressIndicator(
                              minHeight: 16,
                              value: progress,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent.shade200),
                              backgroundColor: Colors.lightBlueAccent.shade100
                                  .withOpacity(.2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('$percentage %'),
                          const SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: LinearProgressIndicator(
                              minHeight: 16,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent.shade200),
                              backgroundColor: Colors.lightBlueAccent.shade100
                                  .withOpacity(.2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(' '),
                          const SizedBox(height: 8),
                        ],
                      );
                    }
                  }),
            ));
  }

  //
  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    ImageCropper imageCropper = ImageCropper();

    CroppedFile? croppedImage = await imageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.rectangle,
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
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),

        //[todo: web only]
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
    if (croppedImage == null) return;

    setState(() {
      selectedImage = XFile(croppedImage.path);
    });
  }
}
