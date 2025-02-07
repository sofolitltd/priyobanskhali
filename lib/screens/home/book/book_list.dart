//book list
import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/repo.dart';
import '../../../utils/style.dart';
import 'book_details.dart';
import 'see_more_book.dart';

class BookList extends StatelessWidget {
  const BookList({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('book')
            .where('categories', arrayContains: categoryName)
            .orderBy('id', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 220,
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return Container();
          }

          var data = snapshot.data!.docs;

          // card
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.blueGrey.shade100),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // text
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyle.kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 4, 20, 4),
                        child: Text(
                          StringUtils.capitalize(categoryName),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    // fontSize: 18,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                        ),
                      ),

                      //btn
                      GestureDetector(
                          onTap: () {
                            //todo
                            Get.to(SeeMoreBook(categoryName: categoryName));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: const Text(AppRepo.kSeeMoreText)))
                    ],
                  ),
                ),

                // const SizedBox(height: 16),
                //
                SizedBox(
                  height: 265,
                  // color: Colors.blue,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) =>
                        BookCard(data: data[index]),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

//book card
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.data,
  });

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
        log('book id : ${data.get('id')}');

        //
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(
              bookId: data.get('id'),
              title: data.get('title'),
              author: data.get('author'),
              price: data.get('price'),
              stock: data.get('stock'),
              description: data.get('description'),
              image: data.get('image'),
              categories: data.get('categories'),
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.blueGrey.shade100,
            ),
          ],
        ),
        width: 155,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //image
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                //image
                CachedNetworkImage(
                  imageUrl: data.get('image'),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 155,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    height: 155,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),

                // price
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                  margin: const EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      color: data.get('price') == 0
                          ? Colors.green
                          : Colors.blueAccent.shade100,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      )),
                  child: Text(
                    data.get('price') == 0
                        ? 'Free'
                        : '${data.get('price')} ${AppRepo.kTkSymbol}',
                    style: GoogleFonts.hindSiliguri(
                        textStyle: Theme.of(context).textTheme.titleMedium,
                        // height: 1,
                        color: Colors.white),
                  ),
                )
              ],
            ),

            //title
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // title
                    Text(
                      data.get('title'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hindSiliguri(
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        height: 1.2,
                      ),
                    ),

                    // author
                    Text(
                      '${data.get('author')}',
                      style: GoogleFonts.hindSiliguri().copyWith(
                        height: 1.3,
                        color: Colors.blueGrey,
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

//
