import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBffx5fPlvDyb8vd8LUBLCm3fCrgIfp-O0",
    authDomain: "babyshop.firebaseapp.com",
    projectId: "babyshop-7f943",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "495224290854",
    appId: "1:495224290854:android:e5e9c0f18cf965219ef0e7",
    measurementId: "your-measurement-id",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBffx5fPlvDyb8vd8LUBLCm3fCrgIfp-O0",
    appId: "1:495224290854:android:e5e9c0f18cf965219ef0e7",
    messagingSenderId: "495224290854",
    projectId: "babyshop-7f943",
    storageBucket: "babyshop.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "your-ios-api-key",
    appId: "your-ios-app-id",
    messagingSenderId: "your-messaging-sender-id",
    projectId: "your-project-id",
    storageBucket: "your-project.appspot.com",
    iosClientId: "your-ios-client-id",
    iosBundleId: "your-ios-bundle-id",
  );

  static const FirebaseOptions macos = ios;
}
