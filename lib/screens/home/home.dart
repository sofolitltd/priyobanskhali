import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

import '/screens/home/ebook/ebook_list.dart';
import '/screens/home/search/search_screen.dart';
import '/utils/repo.dart';
import '../../notification/notification_screen.dart';
import 'banner/home_banner.dart';
import 'book/all_book.dart';
import 'book/book_list.dart';
import 'contact/contact_section.dart';
import 'ebook/all_ebook.dart';
import 'emergency/emergency_section.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,

        title: Image.asset(
          AppRepo.kAppLogo,
          height: 28,
          fit: BoxFit.cover,
        ),

        //todo: add notification
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const SearchScreen());
            },
            icon: const Icon(
              Iconsax.search_favorite,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const NotificationScreen());
            },
            icon: const Icon(Iconsax.notification, size: 20),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // body
      body: const SingleChildScrollView(
        // physics: BouncingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),

            // banner
            HomeBanner(),

            SizedBox(height: 8),

            ContactSection(),

            SizedBox(height: 32),

            // logo section
            EmergencySection(),

            SizedBox(height: 32),
            CustomBookSection(
              collection: 'book',
              subtitle: 'order for home delivery',
            ),

            SizedBox(height: 24),

            //
            CustomBookSection(
              collection: 'ebook',
              subtitle: 'Download and read instantly',
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class CustomBookSection extends StatelessWidget {
  const CustomBookSection({
    super.key,
    required this.subtitle,
    required this.collection,
  });
  final String subtitle;
  final String collection;

  @override
  Widget build(BuildContext context) {
    List categories = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // title & subtitle
        Container(
          decoration: const BoxDecoration(color: Color(0xff1A6642)),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            children: [
              //
              Text(
                '$collection collection'.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
              ),

              //
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // book list
        Container(
          // color: Colors.white,
          constraints: const BoxConstraints(minHeight: 250),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('${collection}_categories')
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
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length > 3 ? 3 : data.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (collection == 'book') {
                      return BookList(
                        categoryName: data[index].get('category'),
                      );
                    }
                    return EbookList(
                      categoryName: data[index].get('category'),
                    );
                  },
                );
              }),
        ),

        // see all book btn
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ElevatedButton(
            onPressed: () {
              if (collection == 'book') {
                Get.to(AllBook(categories: categories));
              } else {
                Get.to(AllEbook(categories: categories));
              }
              //
            },
            child: Text('See all $collection'),
          ),
        ),
      ],
    );
  }
}
