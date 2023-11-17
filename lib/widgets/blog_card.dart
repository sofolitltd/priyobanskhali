import 'package:flutter/material.dart';
import '/utils/date_time_formatter.dart';

import '../models/blog_model.dart';
import '../screens/blog/blog_details.dart';

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
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 8),
                  Text(
                    blog.title,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: .4,
                          height: 1.2,
                        ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
