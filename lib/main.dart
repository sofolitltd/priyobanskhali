import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database/firebase_options.dart';
import 'screens/auth/splash.dart';
import 'screens/notification/fcm_utils.dart';
import 'utils/repo.dart';
import 'utils/style.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMUtils().initialization();
  // run main app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppRepo.kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          canvasColor: const Color(0xfff4f7fa),
          // canvasColor: Colors.grey,
          primaryColor: const Color(0xff2849a0),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            // backgroundColor: Colors.transparent,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          // cardColor: Colors.blue.shade50,
          fontFamily: GoogleFonts.poppins().fontFamily,

          // elevated btn
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.kPrimaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
              textStyle: GoogleFonts.poppins().copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: .4,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              minimumSize: const Size(48, 48),
              textStyle: GoogleFonts.poppins().copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: .4,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: AppStyle.kPrimaryColor,
          )),
      home: const Splash(),
    );
  }
}
