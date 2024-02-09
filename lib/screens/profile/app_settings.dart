import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/open_app.dart';
import '/screens/profile/change_password.dart';
import '/utils/repo.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins().copyWith(
            color: Colors.black,
          ),
        ),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // pass change
          Text(
            'Change Password',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          // pass
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(top: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              onTap: () {
                Get.to(const ChangePassword());
              },
              visualDensity: const VisualDensity(vertical: -1),
              subtitle: Text(
                'Change your old password',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              title: Text(
                'Change Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(
                  (Icons.lock_outline),
                  color: Colors.purple,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // info title
          Text(
            'Contact us',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          //
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // call
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withNumber(AppRepo.kAdminNumber);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    AppRepo.kAdminNumber,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Call us',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.call),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // facebook
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withUrl(AppRepo.kFacebookLink);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    AppRepo.kFacebookLink,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Facebook',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Image.asset(
                      AppRepo.kFacebookLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),

              // whatsapp
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withUrl(AppRepo.kWhatsAppLink);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    AppRepo.kAdminNumber,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'WhatsApp',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Image.asset(
                      AppRepo.kWhatsAppLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),

              // email
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withEmail(AppRepo.kEmailLink);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    AppRepo.kEmailLink,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Image.asset(
                      AppRepo.kEmailLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),

              // youtube
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () {
                    //
                    OpenApp.withUrl(AppRepo.kYoutubeLink);
                  },
                  visualDensity: const VisualDensity(vertical: -1),
                  subtitle: Text(
                    AppRepo.kYoutubeLink,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  title: Text(
                    'Youtube',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Image.asset(
                      AppRepo.kYoutubeLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //dev
          Text(
            'Develop by',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(),
          ),

          const SizedBox(height: 8),

          // call
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              title: Text(
                'Sofol IT',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Contact to developer',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.blue.shade50.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.network(
                    AppRepo.kDevLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              children: [
                const Divider(height: 8),
                //call
                ListTile(
                  onTap: () {
                    OpenApp.withNumber(AppRepo.kDevMobile);
                  },
                  visualDensity: const VisualDensity(vertical: -4),
                  title: const Text(AppRepo.kDevMobile),
                  subtitle: const Text('call now'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      (Icons.call),
                      color: Colors.green.shade400,
                    ),
                  ),
                ),

                const Divider(height: 8),

                //web
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () {
                    OpenApp.withUrl('https://${AppRepo.kDevWebsite}');
                  },
                  title: const Text(AppRepo.kDevWebsite),
                  subtitle: const Text('visit website'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(
                      (Icons.language),
                      color: Colors.black54,
                    ),
                  ),
                ),

                const Divider(height: 8),

                // email
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  onTap: () {
                    //
                    OpenApp.withEmail(AppRepo.kDevEmail);
                  },
                  title: const Text(AppRepo.kDevEmail),
                  subtitle: const Text('email address'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      (Icons.email),
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
