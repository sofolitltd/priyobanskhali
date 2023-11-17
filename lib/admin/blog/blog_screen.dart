import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priyobanskhali/widgets/blog_card_admin.dart';
import '/models/blog_model.dart';
import '/widgets/blog_card.dart';
import '../blog/add_blog.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Blog', style: TextStyle(color: Colors.black),),
      ),
      floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddBlog(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blog')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No blog Found!'));
          }

          var data = snapshot.data!.docs;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: size.width > 1000 ? size.width * .2 : 12,
              vertical: 12,
            ),
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              BlogModel blog = BlogModel.fromJson(
                  data[index].data() as Map<String, dynamic>);
              return BlogCardAdmin(blog: blog, id: data[index].id);
            },
          );
        },
      ),
    );
  }
}
