import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database/firebase_options.dart';
import 'notification/fcm_api.dart';
import 'screens/auth/splash.dart';
import 'utils/repo.dart';
import 'utils/style.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // fcm
  await FCMApi().initNotifications();

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
          canvasColor: const Color(0xfff8f8f8),
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
