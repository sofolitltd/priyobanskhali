import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/repo.dart';
import '../../../utils/open_app.dart';
import '../../auth/login.dart';
import '../ebook/ebook_details.dart';
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
                  BuyNowButton(
                    bookId: widget.bookId,
                    price: widget.price,
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
}

//
class BuyNowButton extends StatefulWidget {
  final String bookId;
  final int price;

  const BuyNowButton({
    super.key,
    required this.bookId,
    required this.price,
  });

  @override
  State<BuyNowButton> createState() => _BuyNowButtonState();
}

class _BuyNowButtonState extends State<BuyNowButton> {
  final TextEditingController _addressController = TextEditingController();

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 8),
        contentPadding: EdgeInsets.all(16),
        insetPadding: EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shipping Address'),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.clear),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 400),
          child: TextField(
            controller: _addressController,
            minLines: 4,
            maxLines: 7,
            decoration: InputDecoration(
              hintText: 'Enter your address ...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.all(16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final address = _addressController.text.trim();
                if (address.isEmpty) {
                  Fluttertoast.showToast(msg: 'Enter address to continue.');
                  return;
                }

                Navigator.pop(context);
                showPaymentBottomSheet(
                  context,
                  bookType: 'book',
                  bookId: widget.bookId,
                  price: widget.price,
                  address: address,
                );
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => const Login(),
      ).then((v) {
        _showAddressDialog();
      });
    } else {
      _showAddressDialog();
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            Text(
              'Buy now',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
