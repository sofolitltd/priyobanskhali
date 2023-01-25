import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:priyobanskhali/utils/open_app.dart';

class UsersAdmin extends StatelessWidget {
  const UsersAdmin({Key? key}) : super(key: key);

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
              .orderBy('name')
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
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data.get('image') == ''
                                ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                                : data.get('image'),
                          ),
                        ),
                        title: Text(StringUtils.capitalize(data.get('name'),
                            allWords: true)),
                        subtitle: Text('Id: ${data.get('uid')}'),
                        children: [
                          if (data.get('union') != '')
                            // union
                            ListTile(
                              title: Text(
                                'Union',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              subtitle: Text(
                                data.get('union'),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).dividerColor,
                                child: const Icon(
                                  (Icons.location_on),
                                  color: Colors.black,
                                ),
                              ),
                            ),

                          //email
                          ListTile(
                            onTap: () {
                              OpenApp.withEmail(data.get('email'));
                            },
                            title: Text(
                              'Email',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            subtitle: Text(
                              data.get('email'),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).dividerColor,
                              child: const Icon(
                                (Icons.email_rounded),
                                color: Colors.red,
                              ),
                            ),
                            trailing:
                                const Icon(Icons.arrow_right_alt_outlined),
                          ),

                          if (data.get('mobile') != '')
                            //
                            ListTile(
                              onTap: () {
                                OpenApp.withNumber(data.get('mobile'));
                              },
                              title: Text('Mobile',
                                  style: Theme.of(context).textTheme.bodySmall),
                              subtitle: Text(
                                data.get('mobile'),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).dividerColor,
                                child: const Icon(
                                  (Icons.call),
                                  color: Colors.green,
                                ),
                              ),
                              trailing:
                                  const Icon(Icons.arrow_right_alt_outlined),
                            ),
                        ],
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
