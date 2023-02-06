import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../screens/home/home_banner_details.dart';
import 'add_banner.dart';
import 'edit_banner.dart';

class AllBannerAdmin extends StatelessWidget {
  const AllBannerAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Banners',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBanner()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('banners')
              .orderBy('position')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            if (data.isEmpty) {
              return const Center(child: Text('No banner found'));
            }

            return ListView.separated(
              itemCount: data.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (_, index) {
                //
                return GestureDetector(
                  onTap: () {
                    //
                    String image = data[index].get('image');
                    String message = data[index].get('message');

                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeBannerDetails(
                                  image: image,
                                  message: message,
                                )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      child: GridTile(
                        footer: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withOpacity(.9),
                          ),
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //title
                              Flexible(
                                child: Text(
                                  data[index].get('message'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),

                              //delete
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () async {
                                        var id = data[index].id;
                                        var imageUrl = data[index].get('image');

                                        // removeBannerImage
                                        await FirebaseStorage.instance
                                            .refFromURL(imageUrl)
                                            .delete();
                                        // //removeBanner
                                        await FirebaseFirestore.instance
                                            .collection('banners')
                                            .doc(id)
                                            .delete()
                                            .whenComplete(
                                              () => Fluttertoast.showToast(
                                                  msg:
                                                      'Delete banner successfully'),
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                      ),
                                    ),
                                  ),

                                  //edit
                                  Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      onPressed: () {
                                        //
                                        Get.to(
                                          () => EditBanner(
                                            data: data[index],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        child: Image.network(
                          data[index].get('image'),
                          fit: BoxFit.cover,
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
