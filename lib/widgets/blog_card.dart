import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            Hero(
              tag: blog.blogId,
              child: Container(
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 0),
                    Hero(
                      tag: blog.date,
                      child: Text(
                        DTFormatter.dateFormat(blog.date),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              wordSpacing: 1.2,
                              // height: 1.3,
                              letterSpacing: .2,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Hero(
                      tag: blog.title,
                      child: Text(
                        blog.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              letterSpacing: .4,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.hindSiliguri().fontFamily,
                            ),
                      ),
                    ),

                    const Spacer(),

                    //

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LikeCounter(blogId: blog.blogId),

                        const SizedBox(width: 8),

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
                                vertical: 6,
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.comment_bank_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Comment",
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
                        ShareButtonRec(blog: blog),
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

// like btn
class LikeCounter extends StatefulWidget {
  const LikeCounter({super.key, required this.blogId});

  final String blogId;

  @override
  State<LikeCounter> createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  late String _userId;
  late CollectionReference _likesRef;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    _likesRef = FirebaseFirestore.instance
        .collection('blog')
        .doc(widget.blogId)
        .collection('likes');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12.withOpacity(.05),
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.5, horizontal: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: _likesRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return _buildLikeButton(0, false);
            }

            final data = snapshot.data!.docs;
            final likeCount = data.length;
            final userLiked = data.any((doc) => doc.id == _userId);

            return StreamBuilder<DocumentSnapshot>(
              stream: _likesRef.doc(_userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLikeButton(likeCount, userLiked);
                }

                final userData = snapshot.data!;
                final userExists = userData.exists;

                return _buildLikeButton(likeCount, userLiked, userExists);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLikeButton(int likeCount, bool userLiked,
      [bool userExists = true]) {
    return InkWell(
      onTap: () async {
        if (userLiked) {
          Fluttertoast.showToast(msg: 'Unlike');
          await _likesRef.doc(_userId).delete();
        } else {
          Fluttertoast.showToast(msg: 'Like');
          await _likesRef.doc(_userId).set({'uid': _userId});
        }
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 40),
        child: Row(
          children: [
            Icon(
              userLiked ? Icons.favorite : Icons.favorite_outline_rounded,
              size: 16,
              color: userLiked ? Colors.red : Colors.black,
            ),
            const SizedBox(width: 4),
            Container(
                constraints: const BoxConstraints(minWidth: 24),
                color: Colors.transparent,
                child: Text(
                  '$likeCount',
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

//
class ShareButtonRec extends StatefulWidget {
  const ShareButtonRec({super.key, required this.blog});

  final BlogModel blog;

  @override
  State<ShareButtonRec> createState() => _ShareButtonRecState();
}

class _ShareButtonRecState extends State<ShareButtonRec> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12.withOpacity(.05),
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
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
          //
          Share.shareXFiles([XFile(path)],
              text:
                  '${widget.blog.title} \n\n${widget.blog.content} \n\nMore on: $appLink');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ))
              : const Icon(Icons.share, size: 20),
        ),
      ),
    );
  }
}
