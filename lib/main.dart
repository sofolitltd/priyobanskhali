import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';

import 'database/firebase_options.dart';
import 'notification/fcm_api.dart';
import 'screens/dashboard.dart';
import 'utils/repo.dart';
import 'utils/style.dart';

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // run main app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initApp(); // call your async stuff here
  }

  Future<void> _initApp() async {
    await checkForUpdate();
    await FcmApi().initPushNotifications();
  }

  //
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppRepo.kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
        // canvasColor: const Color(0xfff8f8f8),
        // primaryColor: const Color(0xff2849a0),
        // scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,

        cardTheme: CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 4,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(fontSize: 18),
        ),
        // cardColor: Colors.blue.shade50,
        fontFamily: GoogleFonts.hindSiliguri().fontFamily,

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
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: .4,
              color: Colors.black,
            ),
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppStyle.kPrimaryColor,
        ),
      ),
      home: Dashboard(),
    );
  }
}
