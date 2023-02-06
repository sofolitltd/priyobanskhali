import 'package:flutter/material.dart';
import 'package:priyobanskhali/screens/home/book_section.dart';
import 'package:upgrader/upgrader.dart';

import '/utils/repo.dart';
import 'ebook_section.dart';
import 'explore_more.dart';
import 'home_banner.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          AppRepo.kAppLogo,
          height: 32,
          fit: BoxFit.cover,
        ),
      ),
      // body
      body: UpgradeAlert(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              //banner
              HomeBanner(),

              // logo section
              ExploreMore(),

              SizedBox(height: 24),

              // books
              BookSection(),

              SizedBox(height: 16),

              //ebooks
              EbookSection(),
            ],
          ),
        ),
      ),
    );
  }
}
