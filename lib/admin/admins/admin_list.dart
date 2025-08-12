import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AdminList extends StatelessWidget {
  const AdminList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var email = '';

          //
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              titlePadding: const EdgeInsets.only(left: 16),
              actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  const Text('Add admin'),

                  //
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              actions: [
                //
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter an email',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    email = val;
                  },
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (email != '') {
                          FirebaseFirestore.instance
                              .collection('admin')
                              .doc()
                              .set(
                            {
                              'email': email,
                              'role': 'admin',
                            },
                          ).then((value) {
                            Get.back();
                          });
                        }
                        if (kDebugMode) {
                          print('no email');
                        }
                        //
                      },
                      child: const Text('Add Admin')),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('admin').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No admin found'));
            }

            return ListView.separated(
              itemCount: docs.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (_, index) {
                var data = docs[index];
                //
                return GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     data.get('image') == ''
                        //         ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                        //         : data.get('image'),
                        //   ),
                        // ),
                        title: Text(data.get('email')),
                        subtitle: Text('role: ${data.get('role')}'),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete admin'),
                                content: const Text(
                                    'Are you sure to delete this admin?'),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      const SizedBox(width: 16),

                                      //
                                      ElevatedButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('admin')
                                              .doc(data.id)
                                              .delete()
                                              .then(
                                            (value) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Delete admin successfully');

                                              //
                                              Get.back();
                                            },
                                          );
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
