import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shop_details.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              Text(
                'Our\nCollection',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              //
              Text(
                'Lets choose your style!',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    // fontWeight: FontWeight.bold,
                    // height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),
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

                  return productCard(data);
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
productCard(data) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: data.length,
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
              title: data[index].get('title'),
              image: data[index].get('image'),
              price: data[index].get('price'),
              stock: data[index].get('stock'),
              size: data[index].get('size'),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    data[index].get('image'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  bottom: 10,
                ),
                child: Text(
                  data[index].get('title'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
