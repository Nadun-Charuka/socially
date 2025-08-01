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
    apiKey: 'AIzaSyA6-0ln6f-4oyQZYBFDbxgTA5WtwNxbfBM',
    appId: '1:214151294894:web:d4911497bf8858e424a23f',
    messagingSenderId: '214151294894',
    projectId: 'socially-8d7fb',
    authDomain: 'socially-8d7fb.firebaseapp.com',
    storageBucket: 'socially-8d7fb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_rgHq9tpKvW3b4sZAmgrZlY3Jka8pMUI',
    appId: '1:214151294894:android:c9345b87414fc03b24a23f',
    messagingSenderId: '214151294894',
    projectId: 'socially-8d7fb',
    storageBucket: 'socially-8d7fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCH9th_j7V5mcu_tJytLfCpJJE3ROE0Gvg',
    appId: '1:214151294894:ios:79622ddf7b6831a624a23f',
    messagingSenderId: '214151294894',
    projectId: 'socially-8d7fb',
    storageBucket: 'socially-8d7fb.firebasestorage.app',
    iosBundleId: 'com.example.socially',
  );
}
