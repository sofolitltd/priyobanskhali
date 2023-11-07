import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '/admin/shop/add_product.dart';
import '../../screens/shop/shop_details.dart';
import 'edit_product.dart';

enum Menu { edit, delete }

class ShopAdmin extends StatelessWidget {
  const ShopAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Shop',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              ElevatedButton(
                onPressed: () {
                  Get.to(const AddProduct());
                },
                child: const Text(
                  'Add product',
                ),
              ),

              const SizedBox(height: 24),

              //
              Text(
                'All product',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const Divider(),

              const SizedBox(height: 4),
              //
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('shop').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitChasingDots(
                      size: 50,
                      color: Colors.blue,
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No product Found!',
                      ),
                    );
                  }

                  var data = snapshot.data!.docs;

                  return ProductCard(data: data);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

//
class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: .8,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //
            Get.to(
              ShopDetails(
                title: widget.data[index].get('title'),
                image: widget.data[index].get('image'),
                price: widget.data[index].get('price'),
                stock: widget.data[index].get('stock'),
                size: widget.data[index].get('size'),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          widget.data[index].get('image'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        bottom: 8,
                        top: 8,
                      ),
                      child: Text(
                        widget.data[index].get('title'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                //menu
                Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: PopupMenuButton<Menu>(
                        padding: EdgeInsets.zero,
                        // Callback that sets the selected popup menu item.
                        onSelected: (Menu item) async {
                          _selectedMenu = item.name;
                          if (_selectedMenu == Menu.edit.name) {
                            var data = widget.data[index];
                            Get.to(
                              () => EditProduct(
                                data: data,
                              ),
                            );
                          } else {
                            //delete image
                            await FirebaseStorage.instance
                                .refFromURL(widget.data[index].get('image'))
                                .delete()
                                .whenComplete(() {
                              // delete info
                              FirebaseFirestore.instance
                                  .collection('shop')
                                  .doc(widget.data[index].get('id'))
                                  .delete()
                                  .whenComplete(() {
                                //
                                Fluttertoast.showToast(
                                    msg: 'Delete successfully');
                              });
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Menu>>[
                              PopupMenuItem<Menu>(
                                value: Menu.edit,
                                child: Text(
                                    StringUtils.capitalize(Menu.edit.name)),
                              ),
                              PopupMenuItem<Menu>(
                                value: Menu.delete,
                                child: Text(
                                    StringUtils.capitalize(Menu.delete.name)),
                              ),
                            ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
