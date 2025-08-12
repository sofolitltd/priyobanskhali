import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/ebook/see_more_ebook.dart';

class Ebooks extends StatelessWidget {
  const Ebooks({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          'Ebooks',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('ebook')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No book found!'));
          }

          var userBooks = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: userBooks.length,
            itemBuilder: (context, index) {
              var bookId = userBooks[index].get('bookId');

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ebook')
                    .where('id', isEqualTo: bookId)
                    .get(),
                builder: (context, bookSnapshot) {
                  if (bookSnapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (bookSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (bookSnapshot.data == null ||
                      bookSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No book found!'));
                  }

                  var ebookData = bookSnapshot.data!.docs.first;
                  log(ebookData.id);

                  return EbookCardFull(data: ebookData);
                },
              );
            },
          );
        },
      ),
    );
  }
}
