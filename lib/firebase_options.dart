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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuzlHDtHGLqJzH_UHt71KOmCR-EdbjpG0',
    appId: '1:220867444623:android:ca91237bd20d48b314d5fa',
    messagingSenderId: '220867444623',
    projectId: 'dar-alarkam-main-app',
    databaseURL: 'https://dar-alarkam-main-app-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'dar-alarkam-main-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8dShhTvIHkLMpxKE6REwtVXz5CU0u3HM',
    appId: '1:220867444623:ios:a8e54f747279a1f314d5fa',
    messagingSenderId: '220867444623',
    projectId: 'dar-alarkam-main-app',
    databaseURL: 'https://dar-alarkam-main-app-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'dar-alarkam-main-app.appspot.com',
    androidClientId: '220867444623-346stuqdc54sfb4ee2l92gq4p2cjjf2t.apps.googleusercontent.com',
    iosClientId: '220867444623-p0iarcq5hbtvb60hsdr53b8ac2unu6f8.apps.googleusercontent.com',
    iosBundleId: 'com.daralarkam.daralarkamMainApp',
  );
}
