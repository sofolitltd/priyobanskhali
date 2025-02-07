import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/repo.dart';
import 'emergency_details.dart';

class EmergencySection extends StatelessWidget {
  const EmergencySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // explore title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
          child: Text(
            AppRepo.kEmergencyTitleText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
        ),

        //
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('emergency_categories')
              .orderBy('id')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'No contact Found!',
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text(
                  'No contact Found!',
                ),
              );
            }

            var data = snapshot.data!.docs;

            // card
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .78,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                String category = data[index].get('category');
                String image = data[index].get('image');

                //
                return GestureDetector(
                  onTap: () {
                    print(category);
                    Get.to(
                      () => EmergencyDetails(category: category),
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8, color: Colors.blueGrey.shade100),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        //
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black12),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.blueGrey.shade100),
                            ],
                            image: image.isEmpty
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      image,
                                    ),
                                  ),
                          ),
                        ),

                        //
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          alignment: Alignment.center,
                          height: 32,
                          // color: Colors.red,
                          child: Text(
                            category,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hindSiliguri(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
