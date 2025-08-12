import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/open_app.dart';

class EmergencyDetails extends StatelessWidget {
  const EmergencyDetails({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: GoogleFonts.hindSiliguri(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('emergency')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No contact Found!',
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                'No contact Found!',
              ),
            );
          }

          var data = snapshot.data!.docs;

          // card
          return ListView.separated(
            itemCount: data.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              String title = data[index].get('title');
              String contact = data[index].get('contact');

              //
              return GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      title,
                      style:
                          GoogleFonts.hindSiliguri(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.phone_android,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact,
                          style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        OpenApp.withNumber(contact);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
