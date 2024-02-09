import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../notification/fcm_sender.dart';

class AddBookAdmin extends StatefulWidget {
  const AddBookAdmin({super.key});

  @override
  State<AddBookAdmin> createState() => _AddBookAdminState();
}

class _AddBookAdminState extends State<AddBookAdmin> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _bookAuthorController = TextEditingController();
  final TextEditingController _bookStockController = TextEditingController();
  final TextEditingController _bookDescriptionController =
      TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();

  List categories = [];
  List _selectedCategories = [];

  XFile? selectedImage;
  UploadTask? task;

  //
  getCategories() async {
    var ref =
        FirebaseFirestore.instance.collection('book_categories').snapshots();
    await ref.forEach((element) {
      for (var e in element.docs) {
        var category = e.get('category');
        categories.add(category);
      }
      log('cat: $categories');
      setState(() {});
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add book',
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
                //
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
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 100,
                                  color: Colors.black26,
                                ),

                                const SizedBox(height: 8),

                                //
                                ElevatedButton(
                                  onPressed: () => pickImage(),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(40, 40),
                                  ),
                                  child: const Text('Choose image'),
                                )
                              ],
                            )
                          : Image.file(
                              File(selectedImage!.path),
                              // fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // title
                TextFormField(
                  controller: _bookTitleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                    labelText: 'Book name',
                    hintText: 'Priyo ..',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter title" : null,
                ),

                const SizedBox(height: 16),

                // author
                TextFormField(
                  controller: _bookAuthorController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                    labelText: 'Author name',
                    hintText: 'Kazi ..',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter author" : null,
                ),

                const SizedBox(height: 16),

                //
                Row(
                  children: [
                    // price
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _bookPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                          hintText: '100',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter price" : null,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // stock
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _bookStockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          border: OutlineInputBorder(),
                          labelText: 'Stock',
                          hintText: '10',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter stock" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // des
                TextFormField(
                  controller: _bookDescriptionController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Description',
                  ),
                  minLines: 1,
                  maxLines: 8,
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),

                const SizedBox(height: 16),

                //cat
                MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  dialogHeight: 400,
                  chipDisplay: MultiSelectChipDisplay(
                    chipColor: Colors.blue.shade50,
                    textStyle: const TextStyle(color: Colors.black),
                  ),
                  title: const Text('Categories'),
                  buttonText: const Text('Categories'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  // initialValue: _selectedCategories,
                  items: categories.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.LIST,
                  onConfirm: (List values) {
                    setState(() {
                      _selectedCategories = values;
                    });
                  },
                  validator: (values) => (values == null || values.isEmpty)
                      ? "Select category"
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //
          ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload_outlined),
              onPressed: () async {
                if (selectedImage == null) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: const Text('No image Selected!'),
                        action: SnackBarAction(
                          label: 'Choose image',
                          onPressed: pickImage,
                        ),
                      ),
                    );
                } else if (_formState.currentState!.validate()) {
                  // fire image
                  await uploadImageToFireStore();

                  //
                  FCMSender().sendPushMessage(
                    topic: 'book',
                    title: _bookTitleController.text.trim(),
                    body: _bookDescriptionController.text
                        .trim()
                        .characters
                        .take(150)
                        .toString(),
                  );
                }
              },
              label: const Text('Save')),
        ],
      ),
    );
  }

// upload file to fire store
  uploadImageToFireStore() async {
    // fire storage
    var name = DateTime.now().millisecondsSinceEpoch.toString();

    final filePath = 'book/$name.jpg';

    var task = FirebaseStorage.instance
        .ref(filePath)
        .putFile(File(selectedImage!.path));
    //
    setState(() {});

    if (task == null) return;
    progressDialog(context, task);

    //
    final snapshot = await task.whenComplete(() {});
    var imageUrl = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $downloadedUrl');

    var id = name;
    //
    FirebaseFirestore.instance.collection('book').doc(id).set({
      'id': id,
      'categories': _selectedCategories,
      'title': _bookTitleController.text.trim(),
      'author': _bookAuthorController.text.trim(),
      'price': int.parse(_bookPriceController.text.trim()),
      'stock': int.parse(_bookStockController.text.trim()),
      'description': _bookDescriptionController.text.trim(),
      'image': imageUrl,
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
