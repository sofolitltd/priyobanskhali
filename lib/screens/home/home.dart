import 'package:flutter/material.dart';

import '/utils/repo.dart';
import '../components/book_list.dart';
import 'explore_more.dart';
import 'home_banner.dart';

enum Category { recent, popular }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        // centerTitle: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          AppRepo.kAppLogo,
          height: 32,
          fit: BoxFit.cover,
        ),
        // actions: [
        //   //
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        // ],
      ),

      // body
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //banner
            const HomeBanner(),

            const SizedBox(height: 8),

            // logo section
            const ExploreMore(),

            const SizedBox(height: 16),

            // recent
            BookList(category: Category.recent.name),

            const SizedBox(height: 16),

            // popular
            BookList(category: Category.popular.name),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
