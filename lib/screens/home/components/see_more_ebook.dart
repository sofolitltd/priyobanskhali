import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/repo.dart';
import 'ebook_details.dart';

class SeeMoreEbook extends StatelessWidget {
  const SeeMoreEbook({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringUtils.capitalize(categoryName),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ebook')
              .where('categories', arrayContains: categoryName)
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
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: doc.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  var data = doc[index];

                  //
                  return EbookCardFull(data: data);
                });
          }),
    );
  }
}

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
                  width: 110,
                  height: 145,
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
                height: 145,
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
                        //title
                        Text(
                          widget.data.get('title'),
                          // style: ,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hindSiliguri(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600, height: 1.2),
                          ),
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

                    const Spacer(),

                    //
                    Text(
                      '${widget.data.get('description')}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hindSiliguri().copyWith(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                        height: 1.3,
                      ),
                    ),

                    const Spacer(),
                    // des
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          //
                          Text(
                            'Categories:  ',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .fontSize,
                            ),
                          ),
                          //

                          Row(
                            children: categories
                                .map(
                                  (category) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black12.withOpacity(.05),
                                    ),
                                    child: Text(
                                      '$category',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          GoogleFonts.hindSiliguri().copyWith(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
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
