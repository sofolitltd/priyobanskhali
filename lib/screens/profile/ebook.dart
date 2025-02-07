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
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        // ],
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('ebook')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No book Found!',
              ),
            );
          }

          var doc = snapshot.data!.docs;
          List<String> books = [];
          for (var element in doc) {
            books.add(element.id);
          }

          // return Text(books.toString());
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: doc.length,
            itemBuilder: (context, index) {
              var data = doc[index];
              //
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ebook')
                      .where('id', isEqualTo: data.get('bookId'))
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
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          var data = doc[index];
                          log(data.id);

                          //
                          return EbookCardFull(data: data);
                        });
                  });
              // return BookCardFull(data: data);
            },
          );
        },
      ),
    );
  }
}
