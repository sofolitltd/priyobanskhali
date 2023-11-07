import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

class AddEbookCategories extends StatefulWidget {
  const AddEbookCategories({Key? key}) : super(key: key);

  @override
  State<AddEbookCategories> createState() => _AddEbookCategoriesState();
}

class _AddEbookCategoriesState extends State<AddEbookCategories> {
  @override
  Widget build(BuildContext context) {
    var docId = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ebook categories',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          var ref = FirebaseFirestore.instance.collection('ebook_categories');
          ref.snapshots().forEach(
            (element) {
              docId = element.docs.length + 1;
              print(docId);
            },
          );

          var category = '';

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
                  const Text('Add Category'),

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
                    hintText: 'Enter category name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    category = val.toLowerCase().trim();
                  },
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (category != '') {
                          //
                          await FirebaseFirestore.instance
                              .collection('ebook_categories')
                              .doc()
                              .set(
                            {
                              'category': category,
                              'id': docId,
                            },
                          ).then((value) {
                            Get.back();
                          });
                        } else {
                          Fluttertoast.showToast(msg: 'Enter category name');
                        }
                      },
                      child: const Text('Add category')),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ebook_categories')
              .orderBy('id')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No categories found'));
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        title: Text(data.get('category')),
                        subtitle: Text('id: ${data.get('id')}'),
                        trailing: IconButton(
                          onPressed: () {
                            //
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete category'),
                                content: const Text(
                                    'Are you sure to delete this category?'),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(40, 40)),
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      const SizedBox(width: 8),

                                      //
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(40, 40)),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('ebook_categories')
                                              .doc(data.id)
                                              .delete()
                                              .then(
                                            (value) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Delete category successfully');

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
