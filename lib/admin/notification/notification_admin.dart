import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../notification/fcm_sender.dart'; // Import your FCMSender class

class NotificationAdmin extends StatelessWidget {
  const NotificationAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Notifications', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No notifications found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final title = data['title'] ?? 'No Title';
              final body = data['body'] ?? '';
              final image = data['image'] ?? '';
              final timestamp = data['timestamp']; // Firestore timestamp

              final formattedTime = timestamp != null
                  ? DateFormat('hh:mm a d/M/yyyy').format(timestamp.toDate())
                  : '';

              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  //
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (image.isNotEmpty)
                          Container(
                            height: 150,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade100
                                  .withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(image),
                              ),
                            ),
                          ),

                        //
                        Text(
                          title,
                          style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          body,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),

                        // time
                        Text(
                          formattedTime,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // del
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () async {
                      final docId = data.id;
                      final imageUrl = data['image'] ?? '';

                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Notification"),
                          content: const Text(
                              "Are you sure you want to delete this notification?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      try {
                        // 1. Delete image from Firebase Storage if exists
                        if (imageUrl.isNotEmpty) {
                          final ref = await FirebaseStorage.instance
                              .refFromURL(imageUrl);
                          await ref.delete();
                        }

                        // 2. Delete document from Firestore
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(docId)
                            .delete();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to delete: $e")),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: Text('Push Notification'),
        icon: const Icon(Iconsax.notification),
      ),
    );
  }
}

void _showAddDialog(BuildContext context) {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  File? pickedImageFile;
  bool isLoading = false;
  bool isFormValid = false;

  void validateForm(StateSetter setState) {
    setState(() {
      isFormValid = titleController.text.trim().isNotEmpty &&
          bodyController.text.trim().isNotEmpty;
    });
  }

  Future<void> pickImage(StateSetter setState) async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      pickedImageFile = File(pickedImage.path);
      setState(() {});
    }
  }

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  const Text("Add Notification"),

                  //
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              if (isLoading)
                const Center(
                    child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: LinearProgressIndicator(),
                )),
            ],
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(16),
          titlePadding: EdgeInsets.only(top: 16, left: 16, right: 8),
          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (_) => validateForm(setState),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: bodyController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Type notification here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onChanged: (_) => validateForm(setState),
                  ),
                  const SizedBox(height: 16),

                  //
                  GestureDetector(
                    onTap: () async {
                      await pickImage(setState);
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      dashPattern: const [6, 3],
                      color: Colors.grey,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: pickedImageFile == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_outlined,
                                      color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tap to Pick Image (height:150 px)',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  pickedImageFile!,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          actions: isLoading
              ? []
              : [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () async {
                            final title = titleController.text.trim();
                            final body = bodyController.text.trim();

                            setState(() => isLoading = true);

                            String imageUrl = '';
                            try {
                              if (pickedImageFile != null) {
                                final fileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('notifications/$fileName.jpg');
                                await ref.putFile(pickedImageFile!);
                                imageUrl = await ref.getDownloadURL();
                              }

                              // Save to Firestore
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                'title': title,
                                'body': body,
                                'image': imageUrl,
                                'timestamp': FieldValue.serverTimestamp(),
                              });

                              // Send Push Notification
                              FCMSender fcmSender = FCMSender();

                              //
                              await FCMSender.sendNotification(
                                topic: 'notifications',
                                title: title,
                                body: body,
                                image: imageUrl,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }

                            if (context.mounted) Navigator.pop(context);
                          }
                        : null, // Disabled if form is incomplete
                    child: const Text('Send'),
                  ),
                ],
        );
      },
    ),
  );
}
