import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/blog_model.dart';
import '../screens/blog/blog_details.dart';
import '/screens/blog/comment_screen.dart';
import '/utils/date_time_formatter.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 0),
                    Text(
                      DTFormatter.dateFormat(blog.date),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: .4,
                            height: 1.2,
                            fontFamily: GoogleFonts.hindSiliguri().fontFamily,
                          ),
                    ),

                    const Spacer(),

                    //
                    // likeCommentShare(),

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // //
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     vertical: 5,
                        //     horizontal: 8,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: Colors.blueAccent.shade100.withOpacity(.2),
                        //     borderRadius: BorderRadius.circular(4),
                        //   ),
                        //   child: const Row(
                        //     children: [
                        //       Icon(
                        //         Icons.favorite_outline_rounded,
                        //         size: 16,
                        //       ),
                        //       SizedBox(width: 8),
                        //       Text(
                        //         "1 ",
                        //         style: TextStyle(fontSize: 12),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //
                        // const SizedBox(width: 8),

                        //
                        Material(
                          color: Colors.black12.withOpacity(.05),
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CommentScreen(blogId: blog.blogId),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.comment_bank_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Comments",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        //
                        Material(
                          color: Colors.black12.withOpacity(.05),
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () async {
                              // app link
                              String appLink =
                                  "https://play.google.com/store/apps/details?id=com.sofolit.priyobanskhali";

                              //
                              final imageUrl = blog.image;
                              final url = Uri.parse(imageUrl);
                              final response = await http.get(url);
                              final bytes = response.bodyBytes;

                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.png';
                              File(path).writeAsBytesSync(bytes);
                              //
                              Share.shareXFiles([XFile(path)],
                                  text:
                                      '${blog.title} \n\n${blog.content} \n\nMore on: $appLink');
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Share",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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

Widget likeCommentShare() {
  //
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // //
      // Container(
      //   padding: const EdgeInsets.symmetric(
      //     vertical: 5,
      //     horizontal: 8,
      //   ),
      //   decoration: BoxDecoration(
      //     color: Colors.blueAccent.shade100.withOpacity(.2),
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   child: const Row(
      //     children: [
      //       Icon(
      //         Icons.favorite_outline_rounded,
      //         size: 16,
      //       ),
      //       SizedBox(width: 8),
      //       Text(
      //         "1 ",
      //         style: TextStyle(fontSize: 12),
      //       ),
      //     ],
      //   ),
      // ),
      //
      // const SizedBox(width: 8),

      //
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.blueAccent.shade100.withOpacity(.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.comment_bank_outlined,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              "Comments",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 8),

      //
      Material(
        color: Colors.blueAccent.shade100.withOpacity(.2),
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            //
            Share.share("");
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 12,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.share,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
