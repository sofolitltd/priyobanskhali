// explore card section
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/open_app.dart';
import '../../../utils/repo.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.blueGrey.shade100),
          BoxShadow(blurRadius: 8, color: Colors.blueGrey.shade100),
        ],
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      // padding: const EdgeInsets.all(8),
      child: Container(
        height: 72,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 8,
        ),
        child: ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(width: 1),
          itemCount: exploreList.length,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (exploreList[index].url == AppRepo.kEmailLink) {
                  OpenApp.withEmail(exploreList[index].url);
                } else {
                  OpenApp.withUrl(exploreList[index].url);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Image.asset(
                      exploreList[index].image,
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(height: 8),

                    //text
                    Text(exploreList[index].title,
                        style: GoogleFonts.hindSiliguri(
                            textStyle: Theme.of(context).textTheme.titleSmall)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// explore list
List<Explore> exploreList = [
  Explore(
      title: AppRepo.kFacebookTextBn,
      image: AppRepo.kFacebookLogo,
      url: AppRepo.kFacebookLink),
  Explore(
      title: AppRepo.kWhatsAppTextBn,
      image: AppRepo.kWhatsAppLogo,
      url: AppRepo.kWhatsAppLink),
  Explore(
      title: AppRepo.kEmailTextBn,
      image: AppRepo.kEmailLogo,
      url: AppRepo.kEmailLink),
  Explore(
      title: AppRepo.kYoutubeTextBn,
      image: AppRepo.kYoutubeLogo,
      url: AppRepo.kYoutubeLink),
  Explore(
      title: AppRepo.kWebsiteTextBn,
      image: AppRepo.kAppLogo,
      url: AppRepo.kWebsiteLink),
];

// explore model
class Explore {
  final String title;
  final String image;
  final String url;
  Explore({required this.title, required this.image, required this.url});
}
