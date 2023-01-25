import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/admin/book/add_book_admin.dart';
import 'package:priyobanskhali/admin/book/edit_book_admin.dart';

import '../../screens/components/book_details.dart';
import '../../utils/repo.dart';

class AllBookAdmin extends StatelessWidget {
  const AllBookAdmin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringUtils.capitalize('All book'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBookAdmin()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('books').snapshots(),
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
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: doc.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  var data = doc[index];

                  //
                  return BookCardFull(data: data);
                });
          }),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(
              bookId: widget.data.get('id'),
              title: widget.data.get('title'),
              month: widget.data.get('month'),
              year: widget.data.get('year'),
              description: widget.data.get('description'),
              image: widget.data.get('image'),
              fileUrl: widget.data.get('fileUrl'),
              price: widget.data.get('price'),
              recent: widget.data.get('recent'),
              popular: widget.data.get('popular'),
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
                  width: 100,
                  height: 125,
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
                height: 125,
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
                                                .collection('books')
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
                          'Filter:  ',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri().copyWith(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize,
                            height: 1,
                          ),
                        ),

                        // recent
                        if (widget.data.get('recent'))
                          Text(
                            'Recent',
                            maxLines: 2,
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

                        // popular
                        if (widget.data.get('recent'))
                          Text(
                            ' , ',
                            maxLines: 2,
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

                        if (widget.data.get('popular'))
                          Text(
                            'Popular',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri().copyWith(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                                height: 1,
                                color: Colors.purple),
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
