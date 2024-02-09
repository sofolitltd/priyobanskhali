import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/open_app.dart';

class UsersAdmin extends StatelessWidget {
  const UsersAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('uid', descending: true)
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
              return const Center(child: Text('No user found'));
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total user",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${docs.length}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: docs.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, index) {
                      var data = docs[index];
                      //
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => UserDetails(data: data));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      data.get('image') == ''
                                          ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                                          : data.get('image'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringUtils.capitalize(data.get('name'),
                                          allWords: true),
                                      style: GoogleFonts.hindSiliguri(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text('Id: ${data.get('uid')}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, required this.data});

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringUtils.capitalize(data.get('name'), allWords: true),
          style: GoogleFonts.hindSiliguri(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          data.get('image') == ''
                              ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                              : data.get('image'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringUtils.capitalize(data.get('name'),
                              allWords: true),
                          style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Id: ${data.get('uid')}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //
            if (data.get('union') != '')
              Card(
                margin: const EdgeInsets.only(top: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    'Union',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text(
                    data.get('union'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).dividerColor,
                    child: const Icon(
                      (Icons.location_on),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            Card(
              margin: const EdgeInsets.only(top: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  OpenApp.withEmail(data.get('email'));
                },
                title: Text(
                  'Email',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text(
                  data.get('email'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).dividerColor,
                  child: const Icon(
                    (Icons.email_rounded),
                    color: Colors.red,
                  ),
                ),
                trailing: const Icon(Icons.arrow_right),
              ),
            ),

            if (data.get('mobile') != '')
              Card(
                margin: const EdgeInsets.only(top: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () {
                    OpenApp.withNumber(data.get('mobile'));
                  },
                  title: Text('Mobile',
                      style: Theme.of(context).textTheme.bodySmall),
                  subtitle: Text(
                    data.get('mobile'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).dividerColor,
                    child: const Icon(
                      (Icons.call),
                      color: Colors.green,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_right),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
