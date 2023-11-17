import 'package:flutter/material.dart';
import '/utils/repo.dart';
import 'package:url_launcher/url_launcher.dart';
import '/models/blog_model.dart';
import '/utils/date_time_formatter.dart';


class BlogDetails extends StatelessWidget {
  const BlogDetails({super.key, required this.blog});

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Blog'.toUpperCase(),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(onPressed: () async {
            const url = AppRepo.kFacebookLink;

            if (!await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
            )) {
            throw Exception('Could not launch $url');
            }

          }, icon: const Icon(Icons.facebook_rounded)),
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
                Container(
                  height: size.width > 1000 ? 500 : 300,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade300.withOpacity(.1),
                    image: DecorationImage(

                      fit: size.width > 1000
                          ? BoxFit.contain
                          : BoxFit.fitHeight,
                      image: NetworkImage(blog.image),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .4,
                                  height: 1.2,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        blog.content,
                        style:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  // wordSpacing: 1.2,
                                  // height: 1.3,
                                  // color: Colors.blueGrey,
                                  letterSpacing: .2,
                                  fontWeight: FontWeight.w100,
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
