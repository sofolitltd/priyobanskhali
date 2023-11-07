// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCVXBoJ53k7we1swytgh5cjyXQFq4pFCQ4',
    appId: '1:169532418363:web:7f1b10b0c12320b3d0ef1e',
    messagingSenderId: '169532418363',
    projectId: 'priyobanskhalibd',
    authDomain: 'priyobanskhalibd.firebaseapp.com',
    storageBucket: 'priyobanskhalibd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsbpru9_wcdHSqCB6qNFK8baV98b5jPEk',
    appId: '1:169532418363:android:07217599aa3fd557d0ef1e',
    messagingSenderId: '169532418363',
    projectId: 'priyobanskhalibd',
    storageBucket: 'priyobanskhalibd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9zEi1y9Vb7rC3AwUvJTeetg_VJ9JOGmY',
    appId: '1:169532418363:ios:6d7f60af052db520d0ef1e',
    messagingSenderId: '169532418363',
    projectId: 'priyobanskhalibd',
    storageBucket: 'priyobanskhalibd.appspot.com',
    iosClientId: '169532418363-rrq0um2gnd5ce948vncl89cflqgkaqtj.apps.googleusercontent.com',
    iosBundleId: 'com.sofolit.priyobanskhali',
  );
}