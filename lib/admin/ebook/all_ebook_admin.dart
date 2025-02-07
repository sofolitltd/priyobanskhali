import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/home/ebook/ebook_details.dart';
import '../../utils/repo.dart';
import 'add_ebook_admin.dart';
import 'add_ebook_categories.dart';
import 'edit_ebook_admin.dart';

class AllEbookAdmin extends StatefulWidget {
  const AllEbookAdmin({super.key});

  @override
  State<AllEbookAdmin> createState() => _AllEbookAdminState();
}

class _AllEbookAdminState extends State<AllEbookAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringUtils.capitalize('Ebooks'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Row(
                children: [
                  // add cat
                  ElevatedButton(
                      onPressed: () {
                        Get.to(
                          const AddEbookCategories(),
                        );
                      },
                      child: const Text('Ebook categories')),
                  const SizedBox(
                    width: 16,
                  ),

                  //add book
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 48)),
                      onPressed: () {
                        Get.to(
                          const AddEbookAdmin(),
                        );
                      },
                      child: const Text('Add ebook')),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'All ebook',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),

              const Divider(),

              const SizedBox(height: 4),

              //
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ebook')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.size == 0) {
                      return const Center(
                        child: Text(
                          'No ebook Found!',
                        ),
                      );
                    }

                    var doc = snapshot.data!.docs;
                    //
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          //
                          return EbookCardFull(data: doc[index]);
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

enum Menu { edit, delete }

//
class EbookCardFull extends StatefulWidget {
  const EbookCardFull({
    super.key,
    required this.data,
  });

  final QueryDocumentSnapshot data;

  @override
  State<EbookCardFull> createState() => _EbookCardFullState();
}

class _EbookCardFullState extends State<EbookCardFull> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    List categories = widget.data.get('categories');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EbookDetails(
              bookId: widget.data.get('id'),
              title: widget.data.get('title'),
              month: widget.data.get('month'),
              year: widget.data.get('year'),
              description: widget.data.get('description'),
              image: widget.data.get('image'),
              fileUrl: widget.data.get('fileUrl'),
              price: widget.data.get('price'),
              categories: widget.data.get('categories'),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image, price
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // image
                Container(
                  width: 125,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      scale: 2,
                      image: NetworkImage(widget.data.get('image')),
                    ),
                  ),
                ),

                // price
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  margin: const EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      color: widget.data.get('price') == 0
                          ? Colors.green
                          : Colors.blueAccent.shade100,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(8),
                      )),
                  child: Text(
                    widget.data.get('price') == 0
                        ? 'Free'
                        : '${widget.data.get('price')} ${AppRepo.kTkSymbol}',
                    style: GoogleFonts.hindSiliguri(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        // height: 1,
                        color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // text
            Expanded(
              // flex: 4,
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // title, sub
                    Column(
                      ///title
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title, menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title
                            Expanded(
                              child: Text(
                                widget.data.get('title'),
                                // style: ,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.hindSiliguri(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          height: 1.2),
                                ),
                              ),
                            ),

                            //menu
                            Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: PopupMenuButton<Menu>(
                                    padding: EdgeInsets.zero,
                                    // Callback that sets the selected popup menu item.
                                    onSelected: (Menu item) {
                                      setState(() async {
                                        _selectedMenu = item.name;
                                        if (_selectedMenu == Menu.edit.name) {
                                          Get.to(() => EditEbookAdmin(
                                              data: widget.data));
                                        } else {
                                          //delete image
                                          await FirebaseStorage.instance
                                              .refFromURL(
                                                  widget.data.get('fileUrl'))
                                              .delete();

                                          //delete image
                                          await FirebaseStorage.instance
                                              .refFromURL(
                                                  widget.data.get('image'))
                                              .delete()
                                              .whenComplete(() {
                                            // delete info
                                            FirebaseFirestore.instance
                                                .collection('ebook')
                                                .doc(widget.data.id)
                                                .delete()
                                                .whenComplete(() {
                                              //
                                              Fluttertoast.showToast(
                                                  msg: 'Delete successfully');
                                            });
                                          });
                                        }
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<Menu>>[
                                          PopupMenuItem<Menu>(
                                            value: Menu.edit,
                                            child: Text(StringUtils.capitalize(
                                                Menu.edit.name)),
                                          ),
                                          PopupMenuItem<Menu>(
                                            value: Menu.delete,
                                            child: Text(StringUtils.capitalize(
                                                Menu.delete.name)),
                                          ),
                                        ]),
                              ),
                            ),
                          ],
                        ),

                        // month
                        Text(
                          '${widget.data.get('month')} - ${widget.data.get('year')}',
                          maxLines: 1,
                          style: GoogleFonts.hindSiliguri().copyWith(
                            color: Colors.black54,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .fontSize,
                          ),
                        ),

                        //
                      ],
                    ),

                    //
                    Row(
                      children: [
                        //
                        Text(
                          'Categories:  ',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri().copyWith(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize,
                            height: 1,
                          ),
                        ),
                        //

                        Row(
                          children: categories
                              .map(
                                (category) => Text(
                                  '$category, ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.hindSiliguri().copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                    height: 1,
                                    color: Colors.purple,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),

                    // des
                    Text(
                      '${widget.data.get('description')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hindSiliguri().copyWith(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
