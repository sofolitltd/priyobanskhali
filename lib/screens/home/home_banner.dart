import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_banner_details.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('banners')
            .orderBy('position')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }

          return Carousel(
            onImageTap: (index) {
              String image = data[index].get('image');
              String message = data[index].get('message');

              //
              Get.to(
                HomeBannerDetails(
                  image: image,
                  message: message,
                ),
                transition: Transition.fadeIn,
              );
            },
            autoplay: true,

            autoplayDuration: const Duration(seconds: 10),
            dotPosition: DotPosition.bottomCenter,
            dotIncreasedColor: Colors.red,
            dotBgColor: Colors.transparent,
            // borderRadius: true,
            images: data
                .map(
                  (image) => CachedNetworkImage(
                    imageUrl: image.get('image'),
                    imageBuilder: (context, imageProvider) => Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
