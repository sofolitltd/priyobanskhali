import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../admin/admin_dashboard.dart';
import '../app_settings.dart';
import '../auth/splash.dart';
import 'edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //
                Get.to(const AppSettings());
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'No data Found!',
                ),
              );
            }

            var data = snapshot.data!;

            // card
            return ProfileCard(data: data);
          }),
    );
  }
}

// card
class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: data.get('image') == ''
                          ? CircleAvatar(
                              radius: 56,
                              backgroundColor: Colors.blue.shade50,
                            )
                          : CircleAvatar(
                              radius: 56,
                              backgroundImage: NetworkImage(data.get('image')),
                            ),
                    ),

                    const SizedBox(width: 16),

                    //
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text(
                            StringUtils.capitalize(data.get('name')),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),

                          // id
                          Row(
                            children: [
                              const Text('Id:  '),
                              SelectableText(
                                '${data.get('uid')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          //
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 45),
                              ),
                              onPressed: () {
                                Get.to(EditProfile(data: data));
                              },
                              child: const Text('Edit profile')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // info title
            Text(
              'User information',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(),
            ),

            const SizedBox(height: 8),

            // info details
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    if (data.get('mobile') != '')
                      // union
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        subtitle: Text(
                          'Union name',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        title: Text(
                          data.get('union'),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            (Icons.location_on),
                            color: Colors.black,
                          ),
                        ),
                      ),

                    if (data.get('mobile') != '') const Divider(height: 2),

                    //email
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -2),
                      subtitle: Text(
                        'Email address',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      title: Text(
                        data.get('email'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          (Icons.email_rounded),
                          color: Colors.red,
                        ),
                      ),
                    ),

                    if (data.get('mobile') != '') const Divider(height: 2),
                    if (data.get('mobile') != '')

                      //
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        subtitle: Text('Mobile number',
                            style: Theme.of(context).textTheme.bodySmall),
                        title: Text(
                          data.get('mobile'),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            (Icons.call),
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            //admin
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .where('email',
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Container();
                  }

                  // card
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // title
                      Text(
                        'Admin',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(),
                      ),

                      const SizedBox(height: 8),

                      //
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).dividerColor,
                            child: const Icon(
                              (Icons.admin_panel_settings_outlined),
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          title: Text(
                            'Admin',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('Manage app content'),
                          onTap: () {
                            //
                            Get.to(const AdminDashboard());
                          },
                        ),
                      ),
                    ],
                  );
                }),

            const SizedBox(height: 16),

            // info title
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(),
            ),

            const SizedBox(height: 8),

            // log out
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                trailing: const Icon(Icons.arrow_right_alt_outlined),
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Icon(
                    (Icons.logout_outlined),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Log out',
                  // textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('leave for now'),
                onTap: () {
                  //
                  FirebaseAuth.instance.signOut();

                  //
                  Get.offAll(const Splash());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
