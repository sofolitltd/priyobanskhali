import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'components/all_ebook.dart';
import 'components/ebook_list.dart';

class EbookSection extends StatelessWidget {
  const EbookSection({super.key});

  @override
  Widget build(BuildContext context) {
    List categories = [];

    return Column(
      children: [
        // ebooks
        Container(
          decoration: const BoxDecoration(color: Color(0xff1A6642)),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            children: [
              //
              Text(
                'Ebook collection',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),

              //
              Text(
                'Download and read instantly',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                      letterSpacing: .5,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ebook list
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ebook_categories')
                .orderBy('id')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
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
                  //
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length > 3 ? 3 : data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 32),
                    itemBuilder: (context, index) => EbookList(
                      categoryName: data[index].get('category'),
                    ),
                  ),

                  // all ebook
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        //
                        Get.to(AllEbook(categories: categories));
                      },
                      child: const Text('See all ebook'),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            }),
      ],
    );
  }
}
