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
        title: Text(
          AppRepo.kAppName,
          style: GoogleFonts.hindSiliguri().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //image
          SizedBox(
            height: 200,
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),

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
