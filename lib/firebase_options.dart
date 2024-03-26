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
        return macos;
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
    apiKey: 'AIzaSyDVkAhaE83HvJHYrLtRuOWdhIyEGMJx1EY',
    appId: '1:191744631070:web:5d259e949aff8bcb47a90f',
    messagingSenderId: '191744631070',
    projectId: 'attendify-application',
    authDomain: 'attendify-application.firebaseapp.com',
    storageBucket: 'attendify-application.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBanVbnplxHSkqjCK33McTbPYL5WAlGx5Q',
    appId: '1:191744631070:android:0ffd4257e12a2dff47a90f',
    messagingSenderId: '191744631070',
    projectId: 'attendify-application',
    storageBucket: 'attendify-application.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9VZZEcbVpAQ3EEPzS_py2ol4vU5fCLmI',
    appId: '1:191744631070:ios:8d6ecfab9317ac7e47a90f',
    messagingSenderId: '191744631070',
    projectId: 'attendify-application',
    storageBucket: 'attendify-application.appspot.com',
    iosBundleId: 'com.example.attendify1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9VZZEcbVpAQ3EEPzS_py2ol4vU5fCLmI',
    appId: '1:191744631070:ios:ae25787264cc212847a90f',
    messagingSenderId: '191744631070',
    projectId: 'attendify-application',
    storageBucket: 'attendify-application.appspot.com',
    iosBundleId: 'com.example.attendify1.RunnerTests',
  );
}