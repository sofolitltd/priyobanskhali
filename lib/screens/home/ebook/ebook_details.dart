import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '/utils/open_app.dart';
import '/utils/repo.dart';
import '../../auth/login.dart';
import '../choose_payment.dart';
import '../pdf_viewer_cached.dart';
import 'ebook_list.dart';

class EbookDetails extends StatefulWidget {
  const EbookDetails({
    super.key,
    required this.bookId,
    required this.title,
    required this.month,
    required this.year,
    required this.description,
    required this.image,
    required this.fileUrl,
    required this.price,
    required this.categories,
  });

  final String bookId;
  final String title;
  final String month;
  final String year;
  final String description;
  final String image;
  final String fileUrl;
  final int price;
  final List categories;

  @override
  State<EbookDetails> createState() => _EbookDetailsState();
}

class _EbookDetailsState extends State<EbookDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.hindSiliguri().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          // sec 1 - title
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image
                CachedNetworkImage(
                  imageUrl: widget.image,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 115,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    width: 115,
                    height: 140,
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

                const SizedBox(width: 8),

                // text
                Expanded(
                  // flex: 4,
                  child: Container(
                    // height: 125,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // title, sub
                        Column(
                          ///title
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              // style: ,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.hindSiliguri(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                              ),
                            ),

                            // month
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // month
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        'Month:',
                                        style: GoogleFonts.lato().copyWith(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .fontSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // month
                                      Text(
                                        widget.month,
                                        maxLines: 1,
                                        style:
                                            GoogleFonts.hindSiliguri().copyWith(
                                          color: Colors.purple,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 4),

                                // year
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        'Year:',
                                        style: GoogleFonts.lato().copyWith(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .fontSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // year
                                      Text(
                                        widget.year,
                                        maxLines: 1,
                                        style:
                                            GoogleFonts.hindSiliguri().copyWith(
                                          color: Colors.purple,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .fontSize,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        // price
                        Column(
                          children: [
                            //
                            if (widget.price == 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.green,
                                ),
                                child: const Text(
                                  'Free',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    'price:',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),

                                  //
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // price
                                      Text(
                                        '${widget.price}',
                                        style:
                                            GoogleFonts.hindSiliguri().copyWith(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontSize,
                                          height: 1.2,
                                        ),
                                      ),

                                      const SizedBox(width: 4),

                                      //title
                                      Text(
                                        AppRepo.kTkSymbol,
                                        style: GoogleFonts.lato().copyWith(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .fontSize,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

          const SizedBox(height: 16),

          //sec 2 - download/buy
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                children: [
                  if (widget.price == 0)
                    InkWell(
                      onTap: () async {
                        // view pdf
                        Get.to(PdfViewerCached(
                          title: widget.title,
                          url: widget.fileUrl,
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chrome_reader_mode_outlined,
                              size: 20,
                              color: Colors.black,
                            ),

                            SizedBox(width: 12),

                            //
                            Text(
                              'Read now',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )

                  // var doc = snapshot.data!.docs;

                  //
                  else
                    InkWell(
                      onTap: () async {
                        final currentUser = FirebaseAuth.instance.currentUser;

                        if (currentUser == null) {
                          showDialog(
                              context: context,
                              builder: (context) => Login()).then((v) {
                            // setState(() {});
                            showPaymentBottomSheet(
                              context,
                              bookType: 'ebook',
                              bookId: widget.bookId,
                              price: widget.price,
                              address: '',
                            );
                          });
                        } else {
                          showPaymentBottomSheet(
                            context,
                            bookType: 'ebook',
                            bookId: widget.bookId,
                            price: widget.price,
                            address: '',
                          );
                        }
                        //
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 20,
                                color: Colors.white,
                              ),

                              SizedBox(width: 12),

                              //
                              Text(
                                'Buy now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // call to support
                  Material(
                    // color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      // tileColor: Colors.white,
                      onTap: () {
                        //call
                        OpenApp.withNumber(AppRepo.kAdminNumber);
                      },
                      visualDensity: const VisualDensity(vertical: -4),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Iconsax.call,
                          color: Colors.black.withValues(alpha: .8),
                        ),
                      ),
                      title: const Text(
                        'Support Center ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Call for more query'),
                      trailing: const Icon(
                        Icons.arrow_right_alt_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          //sec 3 -description
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(minHeight: 100),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const Divider(height: 8),
                  const SizedBox(height: 4),

                  // des
                  Text(
                    widget.description,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.hindSiliguri().copyWith(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // more books
          EbookList(
            categoryName: widget.categories[0],
          ),
        ],
      ),
    );
  }
}

// show payment
Future showPaymentBottomSheet(
  BuildContext context, {
  required String bookType,
  required String bookId,
  required int price,
  required String address,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    ),
    builder: (BuildContext context) {
      return ChoosePayment(
        bookType: bookType,
        bookId: bookId,
        price: price,
        address: address,
      );
    },
  );
}
