import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/admin/emergency/edit_emergency_category_admin.dart';

import '/admin/emergency/add_category.dart';
import 'add_contact_admin.dart';

enum Menu { edit, delete }

class EmergencyAdmin extends StatelessWidget {
  const EmergencyAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Emergency',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              ElevatedButton(
                onPressed: () {
                  Get.to(const AddCategory());
                },
                child: const Text(
                  'Add category',
                ),
              ),

              const SizedBox(height: 24),

              //
              Text(
                'All category',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const Divider(),

              const SizedBox(height: 4),

              //
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('emergency_categories')
                    .orderBy('id')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'No contact Found!',
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.size == 0) {
                    return const Center(
                      child: Text(
                        'No contact Found!',
                      ),
                    );
                  }

                  var data = snapshot.data!.docs;

                  // card
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      //
                      return EmergencyCategoryAdminCard(data: data[index]);
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// cart card
class EmergencyCategoryAdminCard extends StatefulWidget {
  const EmergencyCategoryAdminCard({super.key, required this.data});

  final QueryDocumentSnapshot data;

  @override
  State<EmergencyCategoryAdminCard> createState() =>
      _EmergencyCategoryAdminCardState();
}

class _EmergencyCategoryAdminCardState
    extends State<EmergencyCategoryAdminCard> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () =>
                  EmergencyCategoryAdmin(category: widget.data.get('category')),
              transition: Transition.rightToLeftWithFade,
            );
          },
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      image: widget.data.get('image').isEmpty
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.data.get('image'),
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    '${widget.data.get('id')}. ${widget.data.get('category')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        //menu
        Material(
          color: Colors.transparent,
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade50.withOpacity(.8),
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<Menu>(
                padding: EdgeInsets.zero,
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) async {
                  _selectedMenu = item.name;
                  if (_selectedMenu == Menu.edit.name) {
                    var data = widget.data;
                    Get.to(
                      () => EditEmergencyCategoryAdmin(
                        data: data,
                      ),
                    );
                  } else {
                    //delete image
                    await FirebaseStorage.instance
                        .refFromURL(widget.data.get('image'))
                        .delete()
                        .whenComplete(() async {
                      // delete category
                      await FirebaseFirestore.instance
                          .collection('emergency_categories')
                          .doc(widget.data.id)
                          .delete()
                          .whenComplete(() async {
                        // delete category item
                        await FirebaseFirestore.instance
                            .collection('emergency')
                            .where('category',
                                isEqualTo: widget.data.get('category'))
                            .snapshots()
                            .forEach((element) {
                          for (QueryDocumentSnapshot snapshot in element.docs) {
                            snapshot.reference.delete();
                          }
                        });

                        //
                        Fluttertoast.showToast(msg: 'Delete successfully');
                      });
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      PopupMenuItem<Menu>(
                        value: Menu.edit,
                        child: Text(StringUtils.capitalize(Menu.edit.name)),
                      ),
                      PopupMenuItem<Menu>(
                        value: Menu.delete,
                        child: Text(StringUtils.capitalize(Menu.delete.name)),
                      ),
                    ]),
          ),
        ),
      ],
    );
  }
}

// cat
class EmergencyCategoryAdmin extends StatelessWidget {
  const EmergencyCategoryAdmin({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: GoogleFonts.hindSiliguri(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddContactAdmin(category: category),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('emergency')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No category Found!',
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                'No category Found!',
              ),
            );
          }

          var data = snapshot.data!.docs;

          // card
          return ListView.separated(
            itemCount: data.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              String title = data[index].get('title');
              String contact = data[index].get('contact');

              //
              return GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      title,
                      style:
                          GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_android,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              contact,
                              style: GoogleFonts.hindSiliguri(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blueGrey,
                                letterSpacing: .5,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('emergency')
                                .doc(data[index].id)
                                .delete();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
