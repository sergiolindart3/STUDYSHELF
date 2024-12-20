// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCWe819uScQ_v4D8JWFDEAi2ARNwOK3gVc',
    appId: '1:498197770574:web:e2387a813dce480329ee1f',
    messagingSenderId: '498197770574',
    projectId: 'studyshelf-22adc',
    authDomain: 'studyshelf-22adc.firebaseapp.com',
    storageBucket: 'studyshelf-22adc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClXTYqs0wrgEN4_DB1kKeNVBi5An7vTZg',
    appId: '1:498197770574:android:7b3fa17bb425138329ee1f',
    messagingSenderId: '498197770574',
    projectId: 'studyshelf-22adc',
    storageBucket: 'studyshelf-22adc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXg_Dn0ORoH_dwbyaGoxdKnGEsF2QqlVk',
    appId: '1:498197770574:ios:26cc7eb4c80ef5e029ee1f',
    messagingSenderId: '498197770574',
    projectId: 'studyshelf-22adc',
    storageBucket: 'studyshelf-22adc.appspot.com',
    iosBundleId: 'com.example.studyshelf',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCWe819uScQ_v4D8JWFDEAi2ARNwOK3gVc',
    appId: '1:498197770574:web:38bd562bb4d020ce29ee1f',
    messagingSenderId: '498197770574',
    projectId: 'studyshelf-22adc',
    authDomain: 'studyshelf-22adc.firebaseapp.com',
    storageBucket: 'studyshelf-22adc.appspot.com',
  );
}
