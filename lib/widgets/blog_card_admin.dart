import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/blog_model.dart';
import '../screens/blog/blog_details.dart';
import '/utils/date_time_formatter.dart';

class BlogCardAdmin extends StatelessWidget {
  const BlogCardAdmin({
    super.key,
    required this.blog,
    required this.id,
  });

  final BlogModel blog;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetails(blog: blog),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(blog.image),
                ),
              ),
              padding: const EdgeInsets.all(4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          DTFormatter.dateFormat(blog.date),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    wordSpacing: 1.2,
                                    // height: 1.3,
                                    letterSpacing: .2,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          blog.title,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: .4,
                                    height: 1.2,
                                    fontFamily:
                                        GoogleFonts.hindSiliguri().fontFamily,
                                  ),
                        ),
                      ],
                    ),

                    //delete,  edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () async {
                              var imageUrl = blog.image;

                              // removeBannerImage
                              await FirebaseStorage.instance
                                  .refFromURL(imageUrl)
                                  .delete();
                              // //removeBanner
                              await FirebaseFirestore.instance
                                  .collection('blog')
                                  .doc(id)
                                  .delete()
                                  .whenComplete(
                                    () => Fluttertoast.showToast(
                                        msg: 'Delete successfully'),
                                  );
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 18,
                            ),
                          ),
                        ),

                        //todo: edit
                        // Material(
                        //   color: Colors.transparent,
                        //   child: IconButton(
                        //     onPressed: () {
                        //       //
                        //       // Get.to(
                        //       //       () => EditBanner(
                        //       //     data: data[index],
                        //       //   ),
                        //       // );
                        //     },
                        //     icon: const Icon(
                        //       Icons.edit,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
