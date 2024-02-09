import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'see_more_book.dart';

class AllBook extends StatefulWidget {
  const AllBook({
    super.key,
    required this.categories,
  });

  final List categories;

  @override
  State<AllBook> createState() => _AllBookState();
}

class _AllBookState extends State<AllBook> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Book',
            style: TextStyle(
              color: Colors.black,
            ),
          ),

          //tabs
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelStyle: GoogleFonts.hindSiliguri().copyWith(
              fontWeight: FontWeight.w600,
            ),
            tabs: widget.categories
                .map((category) => Tab(
                      text: StringUtils.capitalize(category),
                    ))
                .toList(),
          ),
        ),
        //
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: widget.categories
              .map((category) => AllBookTab(
                    categoryName: category,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

//
class AllBookTab extends StatelessWidget {
  const AllBookTab({
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
          return ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: doc.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                var data = doc[index];

                //
                return BookCardFull(data: data);
              });
        });
  }
}
