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
    apiKey: 'AIzaSyAqCFE0jjqEjQIR93jWL8kwS7rrU29pYAo',
    appId: '1:715214867891:web:b024a25c0b1f33209ccfc6',
    messagingSenderId: '715214867891',
    projectId: 'flutter-acme',
    authDomain: 'flutter-acme.firebaseapp.com',
    databaseURL: 'https://flutter-acme-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-acme.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzPYEY8SHIbgQIg4PyUIx0TlCR4ohNv5c',
    appId: '1:715214867891:android:a7f5edb94fefde449ccfc6',
    messagingSenderId: '715214867891',
    projectId: 'flutter-acme',
    databaseURL: 'https://flutter-acme-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-acme.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrdVUbEwciGrTbOGujI5aZF7J3ZCFQfaY',
    appId: '1:715214867891:ios:06ebac9c36790f4e9ccfc6',
    messagingSenderId: '715214867891',
    projectId: 'flutter-acme',
    databaseURL: 'https://flutter-acme-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-acme.appspot.com',
    iosClientId: '715214867891-o8taimc6e4lk6v8j7otj9dpjinrrq06l.apps.googleusercontent.com',
    iosBundleId: 'com.example.acmeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrdVUbEwciGrTbOGujI5aZF7J3ZCFQfaY',
    appId: '1:715214867891:ios:06ebac9c36790f4e9ccfc6',
    messagingSenderId: '715214867891',
    projectId: 'flutter-acme',
    databaseURL: 'https://flutter-acme-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-acme.appspot.com',
    iosClientId: '715214867891-o8taimc6e4lk6v8j7otj9dpjinrrq06l.apps.googleusercontent.com',
    iosBundleId: 'com.example.acmeApp',
  );
}
