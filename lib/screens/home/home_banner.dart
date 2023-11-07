import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_banner_details.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
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

          var imgList = [];
          for (var element in data) {
            var img = element.get('image');
            imgList.add(img);
          }
          return CarouselWithIndicatorDemo(imgList: imgList);

          // return Carousel(
          //   onImageTap: (index) {
          //     String image = data[index].get('image');
          //     String message = data[index].get('message');
          //
          //     //
          //     Get.to(
          //       HomeBannerDetails(
          //         image: image,
          //         message: message,
          //       ),
          //       transition: Transition.fadeIn,
          //     );
          //   },
          //   autoplay: true,
          //
          //   autoplayDuration: const Duration(seconds: 10),
          //   dotPosition: DotPosition.bottomCenter,
          //   dotIncreasedColor: Colors.red,
          //   dotBgColor: Colors.transparent,
          //   // borderRadius: true,
          //   images: data
          //       .map(
          //         (image) => CachedNetworkImage(
          //           imageUrl: image.get('image'),
          //           imageBuilder: (context, imageProvider) => Container(
          //             margin: const EdgeInsets.all(16),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8),
          //               image: DecorationImage(
          //                 fit: BoxFit.cover,
          //                 image: imageProvider,
          //               ),
          //             ),
          //           ),
          //           placeholder: (context, url) => Container(
          //             margin: const EdgeInsets.all(16),
          //             decoration: BoxDecoration(
          //               color: Colors.blue.shade50,
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //           errorWidget: (context, url, error) =>
          //               const Icon(Icons.error),
          //         ),
          //       )
          //       .toList(),
          // );
        },
      ),
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  final List imgList;

  const CarouselWithIndicatorDemo({super.key, required this.imgList});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: widget.imgList
              .map((item) => ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    item,
                    width: double.infinity,
                  )))
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              disableCenter: true,
              aspectRatio: 2,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 16,
              height: 8,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
