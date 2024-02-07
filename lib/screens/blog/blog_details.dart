import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '/models/blog_model.dart';
import '/utils/date_time_formatter.dart';
import 'comment_screen.dart';

class BlogDetails extends StatelessWidget {
  const BlogDetails({super.key, required this.blog});

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () async {
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
              icon: const Icon(Icons.share)),
          const SizedBox(width: 8),
        ],
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width > 1000 ? size.width * .2 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 72,
                ),
                Container(
                  height: size.width > 1000 ? 500 : 300,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade300.withOpacity(.1),
                    image: DecorationImage(
                      fit:
                          size.width > 1000 ? BoxFit.contain : BoxFit.fitHeight,
                      image: NetworkImage(blog.image),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
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

                      const SizedBox(height: 8),
                      Text(
                        blog.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              letterSpacing: .4,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.hindSiliguri().fontFamily,
                            ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        blog.content,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              // wordSpacing: 1.2,
                              // height: 1.3,
                              // color: Colors.blueGrey,
                              letterSpacing: .2,
                              fontWeight: FontWeight.w100,
                              fontFamily: GoogleFonts.hindSiliguri().fontFamily,
                            ),
                      ),

                      //
                      const SizedBox(height: 24),

                      // Comments
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // title
                          Text(
                            "Comments",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),

                          // see more
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
                                    Text(
                                      "All comments",
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
                      ),
                      const Divider(),

                      // comment list
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('blog')
                            .doc(blog.blogId)
                            .collection('comments')
                            .orderBy('time', descending: true)
                            .limitToLast(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: SizedBox());
                          }

                          var data = snapshot.data!.docs;
                          if (data.isEmpty) {
                            return const Center(
                                child: Text('No comments yet!'));
                          }
                          //

                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const Divider(height: 32),
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 16,
                              vertical: 16,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(data[index].get('uid'))
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const SizedBox();
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        }

                                        var userData = snapshot.data!;
                                        if (!userData.exists) {
                                          return const SizedBox();
                                        }

                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // image
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundImage:
                                                  userData.get('image') != ""
                                                      ? NetworkImage(
                                                          userData.get('image'))
                                                      : null,
                                              backgroundColor: Colors.black12,
                                            ),

                                            const SizedBox(width: 8),

                                            // name
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //name
                                                  Text(
                                                    userData.get('name'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.2,
                                                        ),
                                                  ),

                                                  //time
                                                  Text(
                                                    DTFormatter.dateTimeFormat(
                                                        data[index]
                                                            .get('time')),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 4),

                                            // del btn
                                            if (data[index].get('uid') ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                              Material(
                                                child: InkWell(
                                                  onTap: () async {
                                                    final ref =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('blog')
                                                            .doc(blog.blogId)
                                                            .collection(
                                                                'comments');
                                                    //
                                                    await ref
                                                        .doc(data[index].id)
                                                        .delete()
                                                        .then((value) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Delete comment successfully');
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }),

                                  const SizedBox(height: 4),
                                  //comment
                                  Text(
                                    data[index].get('comment'),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // comment field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: MessageField(
                          ref: FirebaseFirestore.instance
                              .collection('blog')
                              .doc(blog.blogId)
                              .collection('comments'),
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
