import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/open_app.dart';
import '../../utils/repo.dart';

class ExploreMore extends StatelessWidget {
  const ExploreMore({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // explore title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            AppRepo.kExploreText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        //explore body
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          // padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            child: GridView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              children: [
                // facebook
                InkWell(
                  onTap: () {
                    OpenApp.withUrl(AppRepo.kFacebookLink);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Image.asset(
                        AppRepo.kFacebookLogo,
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),

                      //text
                      Text(AppRepo.kFacebookText,
                          style: GoogleFonts.hindSiliguri(
                              textStyle:
                                  Theme.of(context).textTheme.titleSmall)),
                    ],
                  ),
                ),

                // whatsapp
                InkWell(
                  onTap: () {
                    OpenApp.withUrl(AppRepo.kWhatsAppLink);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Image.asset(
                        AppRepo.kWhatsAppLogo,
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),

                      //text
                      Text(AppRepo.kWhatsAppText,
                          style: GoogleFonts.hindSiliguri(
                              textStyle:
                                  Theme.of(context).textTheme.titleSmall)),
                    ],
                  ),
                ),

                // gmail
                InkWell(
                  onTap: () {
                    OpenApp.withEmail(AppRepo.kEmailLink);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Image.asset(
                        AppRepo.kEmailLogo,
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),

                      //text
                      Text(AppRepo.kEmailText,
                          style: GoogleFonts.hindSiliguri(
                              textStyle:
                                  Theme.of(context).textTheme.titleSmall)),
                    ],
                  ),
                ),

                //youtube
                InkWell(
                  onTap: () {
                    OpenApp.withUrl(AppRepo.kYoutubeLink);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Image.asset(
                        AppRepo.kYoutubeLogo,
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(height: 8),

                      //text
                      Text(
                        AppRepo.kYoutubeText,
                        style: GoogleFonts.hindSiliguri(
                          textStyle: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
