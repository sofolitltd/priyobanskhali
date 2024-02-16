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
        backgroundColor: Colors.white10.withOpacity(.01),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(.8),
          foregroundColor: Colors.black,
          child: const BackButton(),
        ),
        actions: [
          //
          ShareButton(blog: blog),
          const SizedBox(width: 8),
        ],
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Hero(
                tag: blog.blogId,
                child: Container(
                  height: 300,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Colors.green.shade300.withOpacity(.1),
                    image: DecorationImage(
                      fit:
                          size.width > 1000 ? BoxFit.contain : BoxFit.fitHeight,
                      image: NetworkImage(blog.image),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Hero(
                      tag: blog.date,
                      child: Text(
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
                    ),

                    const SizedBox(height: 8),
                    Hero(
                      tag: blog.title,
                      child: Text(
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                          return const Text('No comments yet!');
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
                                                      data[index].get('time')),
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
                                                  final ref = FirebaseFirestore
                                                      .instance
                                                      .collection('blog')
                                                      .doc(blog.blogId)
                                                      .collection('comments');
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
                                  style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}

class ShareButton extends StatefulWidget {
  const ShareButton({super.key, required this.blog});
  final BlogModel blog;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white.withOpacity(.8),
      foregroundColor: Colors.black,
      child: IconButton(
        tooltip: 'Share',
        onPressed: () async {
          // app link
          String appLink =
              "https://play.google.com/store/apps/details?id=com.sofolit.priyobanskhali";

          setState(() {
            _isLoading = true;
          });
          //
          final imageUrl = widget.blog.image;
          final url = Uri.parse(imageUrl);
          final response = await http.get(url);
          final bytes = response.bodyBytes;

          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.png';
          File(path).writeAsBytesSync(bytes);

          //
          setState(() {
            _isLoading = false;
          });

          if (!mounted) return;
          //
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                      'Share Blog',
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: const EdgeInsets.all(16),
                    actions: [
                      //fb
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //
                            Share.share(
                              '${widget.blog.title}\n\n${widget.blog.content} \n\nImage:${widget.blog.image} \n\nDownload App: $appLink',
                              subject: widget.blog.title,
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            'Messenger (only)',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      //
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            //
                            Share.shareXFiles(
                              [XFile(path)],
                              text:
                                  '${widget.blog.title} \n\n${widget.blog.content} \n\nMore on: $appLink',
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(Icons.web_stories),
                          label: const Text('All Social Media'),
                        ),
                      ),
                    ],
                  ));
        },
        icon: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ))
            : const Icon(Icons.share, size: 20),
      ),
    );
  }
}
