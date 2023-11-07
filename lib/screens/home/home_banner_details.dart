import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/utils/repo.dart';

class HomeBannerDetails extends StatelessWidget {
  const HomeBannerDetails({
    Key? key,
    required this.image,
    required this.message,
  }) : super(key: key);

  final String image;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppRepo.kAppLogo,
          height: 32,
          fit: BoxFit.cover,
        ),
      ),

      //
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //image

          SizedBox(
            height: 200,
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          // Container(
          //   height: 200,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: NetworkImage()
          //     )
          //   ),
          //   child: Image.network(
          //     image,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // const SizedBox(height: 8),

          //
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: GoogleFonts.hindSiliguri().copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
