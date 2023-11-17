import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String title;
  final String content;
  final Timestamp date;
  final String image;

  BlogModel({
    required this.title,
    required this.content,
    required this.date,
    required this.image,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      title: json['title'],
      date: json['date'],
      content: json['content'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'content': content,
      'image': image,
    };
  }
}