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
import 'ebook_details.dart';
import 'see_more_ebook.dart';

class EbookList extends StatelessWidget {
  const EbookList({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  book list
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ebook')
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
                    //title
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        right: 16,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                            ),
                          ),

                          //btn
                          GestureDetector(
                              onTap: () {
                                //todo
                                Get.to(
                                    SeeMoreEbook(categoryName: categoryName));
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

                    //
                    SizedBox(
                      height: 265,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) =>
                            EbookCard(data: data[index]),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}

//book card
class EbookCard extends StatelessWidget {
  const EbookCard({
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
            builder: (context) => EbookDetails(
              bookId: data.get('id'),
              title: data.get('title'),
              month: data.get('month'),
              year: data.get('year'),
              description: data.get('description'),
              image: data.get('image'),
              fileUrl: data.get('fileUrl'),
              price: data.get('price'),
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
                    //
                    Text(
                      data.get('title'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hindSiliguri(
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        height: 1.3,
                      ),
                    ),

                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${data.get('month')} - ',
                          style: GoogleFonts.hindSiliguri().copyWith(
                            height: 1.3,
                            color: Colors.blueGrey,
                          ),
                        ),

                        //
                        Text(
                          '${data.get('year')}',
                          style: GoogleFonts.hindSiliguri().copyWith(
                            height: 1.5,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
