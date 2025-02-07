import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'all_book.dart';
import 'book_list.dart';

class BookSection extends StatelessWidget {
  const BookSection({super.key});

  @override
  Widget build(BuildContext context) {
    List categories = [];

    return Column(
      children: [
        // books
        Container(
          decoration: const BoxDecoration(color: Color(0xff1A6642)),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            children: [
              //
              Text(
                'Book Collection',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 18,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
              ),

              SizedBox(height: 2),

              //
              Text(
                'order for home delivery',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      letterSpacing: .5,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // new
        Container(
          color: Colors.white,
          constraints: const BoxConstraints(minHeight: 250),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('book_categories')
                  .orderBy('id')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitChasingDots(
                    color: Colors.blue,
                    size: 50,
                  );
                }

                if (snapshot.data!.size == 0) {
                  return const Text(
                    'No book Found!',
                  );
                }

                var data = snapshot.data!.docs;

                for (var element in data) {
                  categories.add(element.get('category'));
                }

                // card
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    //
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length > 3 ? 3 : data.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) => BookList(
                        categoryName: data[index].get('category'),
                      ),
                    ),

                    // all book
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          //
                          Get.to(AllBook(categories: categories));
                        },
                        child: const Text('See all book'),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
