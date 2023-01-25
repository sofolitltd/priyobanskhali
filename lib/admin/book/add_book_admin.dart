import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

List<String> kFilterList = ['Recent', 'Popular'];

class AddBookAdmin extends StatefulWidget {
  const AddBookAdmin({key}) : super(key: key);

  @override
  State<AddBookAdmin> createState() => _AddBookAdminState();
}

class _AddBookAdminState extends State<AddBookAdmin> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _bookMonthController = TextEditingController();
  final TextEditingController _bookYearController = TextEditingController();
  final TextEditingController _bookDescriptionController =
      TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  bool _isRecent = true;
  bool _isPopular = false;

  String? fileName;
  XFile? selectedImage;
  File? selectedFile;
  UploadTask? task;

  // @override
  // void dispose() {
  //   _contentTitleController.dispose();
  //   _contentSubtitleController.dispose();
  //   // _selectedSessionList!.clear();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Upload book',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // choose image
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => pickImage(),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4)),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_outlined),
                          Text('Add image'),
                        ],
                      )
                    : Image.file(
                        File(selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // choose file
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
              horizontalTitleGap: 0,
              shape: const RoundedRectangleBorder(),
              leading: const Icon(Icons.file_copy_outlined),
              title: fileName == null
                  ? const Text('No File Selected',
                      style: TextStyle(color: Colors.red))
                  : SelectableText(
                      fileName!,
                      style: const TextStyle(),
                    ),
              trailing: InkWell(
                onTap: () {
                  pickFile();
                },
                child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //
          Form(
            key: _formState,
            child: Column(
              children: [
                // title
                TextFormField(
                  controller: _bookTitleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'File Title',
                    hintText: 'Introduction',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Chapter Title" : null,
                ),

                const SizedBox(height: 16),

                // month
                TextFormField(
                  controller: _bookMonthController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Month',
                    hintText: 'Month',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter month" : null,
                ),

                const SizedBox(height: 16),

                // year
                TextFormField(
                  controller: _bookYearController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Year',
                    hintText: 'Year',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter year" : null,
                ),

                const SizedBox(height: 16),

                // price
                TextFormField(
                  controller: _bookPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Price',
                  ),
                  validator: (value) => value!.isEmpty ? "Enter price" : null,
                ),

                const SizedBox(height: 16),

                // des
                TextFormField(
                  controller: _bookDescriptionController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Description',
                  ),
                  minLines: 4,
                  maxLines: 8,
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),

                const SizedBox(height: 16),

                // //recent / popular
                // ButtonTheme(
                //   alignedDropdown: true,
                //   child: DropdownButtonFormField(
                //     value: _selectedFilter,
                //     hint: const Text('Filter as'),
                //     // isExpanded: true,
                //     decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       contentPadding:
                //           EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                //     ),
                //     onChanged: (String? value) {
                //       setState(() {
                //         _selectedFilter = value;
                //       });
                //     },
                //     // validator: (value) =>
                //     //     value == null ? kSelectYourUnionText : null,
                //     items: kFilterList.map((String val) {
                //       return DropdownMenuItem(
                //         value: val,
                //         child: Text(
                //           val,
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),

                // session list

                //

                //
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                          value: _isRecent,
                          title: const Text('Recent'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? newValue) {
                            setState(() {
                              //
                              _isRecent = newValue!;
                            });
                          }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CheckboxListTile(
                          value: _isPopular,
                          title: const Text('Popular'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? newValue) {
                            setState(() {
                              //
                              _isPopular = newValue!;
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload_outlined),
                onPressed: () async {
                  if (fileName == null) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'No File Selected !');
                  } else if (selectedImage == null) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'No image Selected!');
                  } else if (_formState.currentState!.validate()) {
                    // fire storage
                    var fileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    //
                    task = putFileToFireStorage(
                      file: selectedFile!,
                      name: '$fileName.pdf',
                    );
                    setState(() {});

                    if (task == null) return;
                    progressDialog(context, task!);

                    // download link
                    final snapshot = await task!.whenComplete(() {});
                    var downloadedUrl = await snapshot.ref.getDownloadURL();
                    // print('link$downloadedUrl');

                    // fire store
                    await uploadFileToFireStore(
                        fileUrl: downloadedUrl, name: fileName);

                    //
                    Navigator.pop(this.context);
                  }
                },
                label: const Text('Upload book')),
          ),
        ],
      ),
    );
  }

  // pick file
  pickFile() async {
    //open file manager
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    //
    if (result != null) {
      final name = result.files.first.name;
      final path = result.files.first.path!;
      // fileType = result.files.first.extension;
      // print(fileType);

      setState(() {
        fileName = name;
        //
        selectedFile = File(path);
      });
    } else {
      // User canceled the picker
    }
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

  // upload file to storage
  UploadTask? putFileToFireStorage({required File file, required String name}) {
    if (selectedFile == null) return null;

    //
    var path = 'books/$name';

    try {
      final ref = FirebaseStorage.instance.ref(path);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
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

  // upload file to fire store
  uploadFileToFireStore({
    required String fileUrl,
    required String name,
  }) async {
    final filePath = 'images/$name.jpg';

    var task = FirebaseStorage.instance
        .ref(filePath)
        .putFile(File(selectedImage!.path));
    //
    setState(() {});

    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    var imageUrl = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $downloadedUrl');

    var id = name;
    //
    FirebaseFirestore.instance.collection('books').doc(id).set({
      'id': id,
      'title': _bookTitleController.text.trim(),
      'month': _bookMonthController.text.trim(),
      'year': _bookYearController.text.trim(),
      'description': _bookDescriptionController.text.trim(),
      'image': imageUrl,
      'fileUrl': fileUrl,
      'price': int.parse(_bookPriceController.text.trim()),
      'recent': _isRecent,
      'popular': _isPopular,
    });

    //
    if (!mounted) return;
    Navigator.pop(context);
  }
}
