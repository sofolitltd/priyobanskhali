import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/screens/home/book_section.dart';
import '/screens/home/search/search_screen.dart';
import '/utils/repo.dart';
import 'ebook_section.dart';
import 'explore_more.dart';
import 'home_banner.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white12,
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
              Icons.search,
              size: 20,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Get.to(() => const NotificationScreen());
          //   },
          //   icon: const Icon(Icons.notifications_outlined, size: 20),
          // ),
          const SizedBox(width: 8),
        ],
      ),
      // body
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //banner
            HomeBanner(),

            // logo section
            ExploreMore(),

            SizedBox(height: 24),

            // books
            BookSection(),

            SizedBox(height: 32),

            //ebooks
            EbookSection(),
          ],
        ),
      ),
    );
  }
}
