import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pdf_viewer_cached.dart';
import '/screens/payment/bkash_gateway.dart';
import '/utils/open_app.dart';
import '/utils/repo.dart';
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
                  //
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('books')
                          .where('bookId', isEqualTo: widget.bookId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Something wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return InkWell(
                            onTap: null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 20,
                                    color: Colors.grey,
                                  ),

                                  SizedBox(width: 12),

                                  //
                                  Text(
                                    'Loading',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (snapshot.data!.size == 0) {
                          return widget.price == 0
                              ? InkWell(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              : InkWell(
                                  onTap: () async {
                                    //
                                    showPaymentBottomSheet(context);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }

                        // var doc = snapshot.data!.docs;

                        //
                        return InkWell(
                          onTap: () async {
                            // view pdf
                            Get.to(PdfViewerCached(
                                title: widget.title, url: widget.fileUrl));
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
                        );
                      }),

                  const SizedBox(height: 8),

                  // call to support
                  Material(
                    color: Colors.transparent,
                    child: ListTile(
                      // tileColor: Colors.white,
                      onTap: () {
                        //call
                        OpenApp.withNumber(AppRepo.kAdminNumber);
                      },
                      visualDensity: const VisualDensity(vertical: -4),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.support_agent,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                      title: const Text('Call now'),
                      subtitle: const Text('call for more query'),
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

  Future showPaymentBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return ChosePayment(
          price: 10,
          bookId: widget.bookId,
        );
      },
    );
  }
}

//
class ChosePayment extends StatefulWidget {
  const ChosePayment({super.key, required this.price, required this.bookId});
  final double price;
  final String bookId;

  @override
  State<ChosePayment> createState() => _PaymentState();
}

class _PaymentState extends State<ChosePayment> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          Text(
            'Choose payment method',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const Divider(),

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'price:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Text(
                        '${widget.price}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                      ),
                      const SizedBox(width: 4),

                      //
                      Text(
                        AppRepo.kTkSymbol,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),

              //
              isLoading ? const CircularProgressIndicator() : Container(),
            ],
          ),

          const SizedBox(height: 16),

          //bkash tile
          ListTile(
            tileColor: isLoading ? Colors.pink.shade50 : null,
            onTap: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await BkashGateway.paymentCheckout(
                        context, 1, widget.bookId);
                    setState(() => isLoading = true);
                  },
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Image.asset(
              AppRepo.kBkashLogo,
              width: 56,
              height: 56,
            ),
            title: const Text('bkash'),
            subtitle: const Text('pay with your bkash number'),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
