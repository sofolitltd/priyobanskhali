import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/open_app.dart';
import '/screens/payment/place_order.dart';
import '/utils/repo.dart';
import 'book_list.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
    required this.categories,
  });

  final String bookId;
  final String title;
  final String description;
  final String author;
  final int price;
  final int stock;
  final String image;
  final List categories;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
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

                const SizedBox(width: 5),

                // text
                Expanded(
                  // flex: 4,
                  child: Container(
                    height: 140,
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
                            //title
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

                            // author
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //title
                                Text(
                                  'author:  ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),

                                // author
                                Text(
                                  widget.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.hindSiliguri().copyWith(
                                    color: Colors.black87,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .fontSize,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Text(
                                  'price:',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),

                                //
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            .titleLarge!
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

          // sec 2 - download/buy
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
                  // StreamBuilder<QuerySnapshot>(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('users')
                  //         .doc(FirebaseAuth.instance.currentUser!.uid)
                  //         .collection('books')
                  //         .where('bookId', isEqualTo: widget.bookId)
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasError) {
                  //         return const Center(child: Text('Something wrong'));
                  //       }
                  //
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return InkWell(
                  //           onTap: null,
                  //           child: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //               vertical: 12,
                  //               horizontal: 16,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey.shade100,
                  //               borderRadius: BorderRadius.circular(4),
                  //             ),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: const [
                  //                 Icon(
                  //                   Icons.access_time_rounded,
                  //                   size: 20,
                  //                   color: Colors.grey,
                  //                 ),
                  //
                  //                 SizedBox(width: 12),
                  //
                  //                 //
                  //                 Text(
                  //                   'Loading',
                  //                   style: TextStyle(color: Colors.grey),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //
                  //       if (snapshot.data!.size == 0) {
                  //         return widget.price == 0
                  //             ? InkWell(
                  //                 onTap: () async {
                  //                   // view pdf
                  //                 },
                  //                 child: Container(
                  //                   padding: const EdgeInsets.symmetric(
                  //                     vertical: 12,
                  //                     horizontal: 16,
                  //                   ),
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.greenAccent.shade100,
                  //                     borderRadius: BorderRadius.circular(4),
                  //                   ),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: const [
                  //                       Icon(
                  //                         Icons.chrome_reader_mode_outlined,
                  //                         size: 20,
                  //                         color: Colors.black,
                  //                       ),
                  //
                  //                       SizedBox(width: 12),
                  //
                  //                       //
                  //                       Text(
                  //                         'Read now',
                  //                         style: TextStyle(color: Colors.black),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               )
                  //             : InkWell(
                  //                 onTap: () async {
                  //                   //
                  //                   showModalBottomSheet<void>(
                  //                     context: context,
                  //                     shape: const RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(8),
                  //                         topRight: Radius.circular(8),
                  //                       ),
                  //                     ),
                  //                     builder: (BuildContext context) {
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(16),
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           mainAxisSize: MainAxisSize.min,
                  //                           children: [
                  //                             //
                  //                             Text(
                  //                               'Choose payment method',
                  //                               style: Theme.of(context)
                  //                                   .textTheme
                  //                                   .titleMedium,
                  //                             ),
                  //
                  //                             const Divider(),
                  //
                  //                             //
                  //                             Text(
                  //                               'price:',
                  //                               style: Theme.of(context)
                  //                                   .textTheme
                  //                                   .labelMedium,
                  //                             ),
                  //                             Row(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 //
                  //                                 Text(
                  //                                   '${widget.price}',
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headline5!
                  //                                       .copyWith(
                  //                                           color: Colors
                  //                                               .redAccent,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                           height: 1.2),
                  //                                 ),
                  //                                 const SizedBox(width: 4),
                  //
                  //                                 //
                  //                                 Text(
                  //                                   AppRepo.kTkSymbol,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .labelMedium,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //
                  //                             const SizedBox(height: 16),
                  //
                  //                             //bkash tile
                  //                             ListTile(
                  //                               onTap: () async {
                  //                                 Get.to(
                  //                                   PlaceOrder(
                  //                                     method: 'Bkash',
                  //                                     id: widget.bookId,
                  //                                     title: widget.title,
                  //                                     month: widget.author,
                  //                                     year: widget.stock,
                  //                                     price: widget.price,
                  //                                   ),
                  //                                 );
                  //                               },
                  //                               shape: RoundedRectangleBorder(
                  //                                 side: BorderSide(
                  //                                     width: 1,
                  //                                     color: Theme.of(context)
                  //                                         .dividerColor),
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(8),
                  //                               ),
                  //                               leading: Image.asset(
                  //                                 AppRepo.kBkashLogo,
                  //                                 width: 56,
                  //                                 height: 56,
                  //                               ),
                  //                               title: const Text('bkash'),
                  //                               subtitle: const Text(
                  //                                   'pay with your bkash number'),
                  //                             ),
                  //
                  //                             const SizedBox(height: 8),
                  //                           ],
                  //                         ),
                  //                       );
                  //                     },
                  //                   );
                  //                 },
                  //                 child: Material(
                  //                   color: Colors.transparent,
                  //                   child: Container(
                  //                     padding: const EdgeInsets.symmetric(
                  //                       vertical: 12,
                  //                       horizontal: 16,
                  //                     ),
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.blueAccent.shade100,
                  //                       borderRadius: BorderRadius.circular(4),
                  //                     ),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       children: const [
                  //                         Icon(
                  //                           Icons.shopping_cart_outlined,
                  //                           size: 20,
                  //                           color: Colors.white,
                  //                         ),
                  //
                  //                         SizedBox(width: 12),
                  //
                  //                         //
                  //                         Text(
                  //                           'Buy now',
                  //                           style:
                  //                               TextStyle(color: Colors.white),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //       }
                  //
                  //       // var doc = snapshot.data!.docs;
                  //
                  //       //
                  //       return InkWell(
                  //         onTap: () async {
                  //           // view pdf
                  //           Get.to(PdfViewerCached(
                  //               title: widget.title, url: widget.fileUrl));
                  //         },
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(
                  //             vertical: 12,
                  //             horizontal: 16,
                  //           ),
                  //           decoration: BoxDecoration(
                  //             color: Colors.greenAccent.shade100,
                  //             borderRadius: BorderRadius.circular(4),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: const [
                  //               Icon(
                  //                 Icons.chrome_reader_mode_outlined,
                  //                 size: 20,
                  //                 color: Colors.black,
                  //               ),
                  //
                  //               SizedBox(width: 12),
                  //
                  //               //
                  //               Text(
                  //                 'Read now',
                  //                 style: TextStyle(color: Colors.black),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }),

                  // buy
                  GestureDetector(
                    onTap: () {
                      //todo: fix payment
                      showPaymentBottomSheet(context);
                    },
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
                        )),
                  ),

                  const SizedBox(height: 10),

                  // chat
                  InkWell(
                    onTap: () async {
                      //
                      OpenApp.withUrl(AppRepo.kWhatsAppLink);
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppRepo.kWhatsAppLogo,
                            height: 20,
                            width: 20,
                            color: Colors.black,
                          ),

                          const SizedBox(width: 12),

                          //
                          const Text(
                            'Chat now',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
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
                  Text('Description',
                      style: Theme.of(context).textTheme.titleMedium),

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
          BookList(
            categoryName: widget.categories[0],
          ),
        ],
      ),
    );
  }

  //
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
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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

              const SizedBox(height: 16),

              //bkash tile
              ListTile(
                onTap: () async {
                  //todo: fix later
                  // await paymentCheckout(1);

                  // fix: bkash
                  Get.to(
                    PlaceOrder(
                      method: 'Bkash',
                      id: widget.bookId,
                      title: widget.title,
                      month: widget.author,
                      year: widget.stock.toString(),
                      price: widget.price,
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: Theme.of(context).dividerColor),
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
      },
    );
  }
}
