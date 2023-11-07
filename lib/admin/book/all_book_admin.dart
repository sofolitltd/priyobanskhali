import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '/admin/book/edit_book_admin.dart';
import '../../screens/home/components/book_details.dart';
import '../../utils/repo.dart';
import 'add_book_admin.dart';
import 'add_book_categories.dart';

class AllBookAdmin extends StatefulWidget {
  const AllBookAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<AllBookAdmin> createState() => _AllBookAdminState();
}

class _AllBookAdminState extends State<AllBookAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringUtils.capitalize('Books'),
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
                          const AddBookCategories(),
                        );
                      },
                      child: const Text('Book categories')),
                  const SizedBox(
                    width: 16,
                  ),

                  //add book
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 48)),
                      onPressed: () {
                        Get.to(
                          const AddBookAdmin(),
                        );
                      },
                      child: const Text('Add book')),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'All book',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),

              const Divider(),

              const SizedBox(height: 4),

              //
              StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('book').snapshots(),
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
                          'No book Found!',
                        ),
                      );
                    }

                    var doc = snapshot.data!.docs;
                    //
                    return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: doc.length,
                        // padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          //
                          return BookCardFull(data: doc[index]);
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
class BookCardFull extends StatefulWidget {
  const BookCardFull({
    Key? key,
    required this.data,
  }) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  State<BookCardFull> createState() => _BookCardFullState();
}

class _BookCardFullState extends State<BookCardFull> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    List categories = widget.data.get('categories');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(
              bookId: widget.data.get('id'),
              title: widget.data.get('title'),
              author: widget.data.get('author'),
              stock: widget.data.get('stock'),
              description: widget.data.get('description'),
              image: widget.data.get('image'),
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
                  width: 110,
                  height: 140,
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
                      color: Colors.blueAccent.shade100,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(8),
                      )),
                  child: Text(
                    '${widget.data.get('price')} ${AppRepo.kTkSymbol}',
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
                height: 140,
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
                                      setState(() {
                                        _selectedMenu = item.name;
                                        if (_selectedMenu == Menu.edit.name) {
                                          Get.to(() =>
                                              EditBookAdmin(data: widget.data));
                                        } else {
                                          //
                                          FirebaseStorage.instance
                                              .refFromURL(
                                                  widget.data.get('image'))
                                              .delete()
                                              .whenComplete(() {
                                            //
                                            FirebaseFirestore.instance
                                                .collection('book')
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
                          '${widget.data.get('author')}',
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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

                          // Text(
                          //   '$categories',
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: GoogleFonts.hindSiliguri().copyWith(
                          //     fontSize: Theme.of(context)
                          //         .textTheme
                          //         .bodyMedium!
                          //         .fontSize,
                          //     height: 1,
                          //     color: Colors.purple,
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // des
                    Text(
                      '${widget.data.get('description')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hindSiliguri().copyWith(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                        height: 1,
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
