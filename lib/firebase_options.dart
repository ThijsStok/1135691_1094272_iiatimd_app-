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
    apiKey: 'AIzaSyA7jFG3tVCBBpXfPvB5rEllqugn88VGqvA',
    appId: '1:742887988123:web:c1e99027c74aaa665d5f3e',
    messagingSenderId: '742887988123',
    projectId: 'health-monitor-97bda',
    authDomain: 'health-monitor-97bda.firebaseapp.com',
    storageBucket: 'health-monitor-97bda.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8P5f-tImLGMaj9pGhxBiAGwomGIL4ziM',
    appId: '1:742887988123:android:1709590605f727fe5d5f3e',
    messagingSenderId: '742887988123',
    projectId: 'health-monitor-97bda',
    storageBucket: 'health-monitor-97bda.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5-JMB6HvS5WrqINpMP5fdAnxvIjPUFmU',
    appId: '1:742887988123:ios:af5e27e033d3c4d55d5f3e',
    messagingSenderId: '742887988123',
    projectId: 'health-monitor-97bda',
    storageBucket: 'health-monitor-97bda.appspot.com',
    iosClientId: '742887988123-djkvovv50nlaeicb9d2d0ej1aa00pn6h.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5-JMB6HvS5WrqINpMP5fdAnxvIjPUFmU',
    appId: '1:742887988123:ios:af5e27e033d3c4d55d5f3e',
    messagingSenderId: '742887988123',
    projectId: 'health-monitor-97bda',
    storageBucket: 'health-monitor-97bda.appspot.com',
    iosClientId: '742887988123-djkvovv50nlaeicb9d2d0ej1aa00pn6h.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
