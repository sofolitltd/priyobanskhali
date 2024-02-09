import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/repo.dart';
import '/screens/home/components/ebook_details.dart';

class Shelf extends StatelessWidget {
  const Shelf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          'Shelf',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        // ],
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('books')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No book Found!',
              ),
            );
          }

          var doc = snapshot.data!.docs;
          List<String> books = [];
          for (var element in doc) {
            books.add(element.id);
          }

          // return Text(books.toString());
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: doc.length,
            itemBuilder: (context, index) {
              var data = doc[index];
              //
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ebook')
                      .where('id', isEqualTo: data.get('bookId'))
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
                          'No book Found!',
                        ),
                      );
                    }

                    var doc = snapshot.data!.docs;
                    //
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          var data = doc[index];
                          log(data.id);

                          //
                          return BookShelfCard(data: data);
                        });
                  });
              // return BookCardFull(data: data);
            },
          );
        },
      ),
    );
  }
}

class BookShelfCard extends StatefulWidget {
  const BookShelfCard({
    super.key,
    required this.data,
  });

  final QueryDocumentSnapshot data;

  @override
  State<BookShelfCard> createState() => _BookShelfCardState();
}

class _BookShelfCardState extends State<BookShelfCard> {
  @override
  Widget build(BuildContext context) {
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
                          ],
                        ),

                        // month
                        Text(
                          '${widget.data.get('month')} - ${widget.data.get('year')}',
                          maxLines: 1,
                          style: GoogleFonts.hindSiliguri().copyWith(
                            color: Colors.purple,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .fontSize,
                          ),
                        ),

                        //
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
