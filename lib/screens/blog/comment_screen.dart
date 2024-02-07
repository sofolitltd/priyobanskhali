import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:priyobanskhali/utils/date_time_formatter.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.blogId});

  final String blogId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('blog')
        .doc(widget.blogId)
        .collection('comments');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref.orderBy("time", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox());
                }

                var data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(child: Text('No comments yet!'));
                }
                //

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // image
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: userData.get('image') != ""
                                        ? NetworkImage(userData.get('image'))
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
                                                fontWeight: FontWeight.bold,
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
                                      FirebaseAuth.instance.currentUser!.uid)
                                    Material(
                                      child: InkWell(
                                        onTap: () async {
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
          ),

          //
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
              vertical: 16,
            ),
            child: MessageField(
              ref: ref,
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
    required this.ref,
    required this.uid,
  });

  final CollectionReference ref;
  final String uid;

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final TextEditingController _messageController = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();

    //
    _messageController.addListener(() {
      final isButtonActive = _messageController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // write comment
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: "Add a comment"),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // sent
        Container(
          padding: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12.withOpacity(.05),
          ),
          child: IconButton(
            onPressed: isButtonActive
                ? () async {
                    log(_messageController.text.trim());

                    //
                    await widget.ref.doc().set({
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'comment': _messageController.text.trim(),
                      'time': DateTime.now(),
                    }).whenComplete(() {
                      _messageController.clear();
                      setState(() {});
                    });
                  }
                : null,
            icon: Icon(
              Icons.send_rounded,
              size: 32,
              color: isButtonActive ? Colors.blueAccent : Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
