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
    apiKey: 'AIzaSyBUBQ36nZweWdn0QXvFliSDeCxDb_ILMJs',
    appId: '1:851967648288:web:b28aa936f6d61984155245',
    messagingSenderId: '851967648288',
    projectId: 'aiot-nano',
    authDomain: 'aiot-nano.firebaseapp.com',
    storageBucket: 'aiot-nano.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLBzSTpjye-dwQC--7JdatVVrEsIK0PqY',
    appId: '1:851967648288:android:27409633c643568b155245',
    messagingSenderId: '851967648288',
    projectId: 'aiot-nano',
    storageBucket: 'aiot-nano.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9rTw3B0VlHr8r_U4OH1t52O81jNtnM2U',
    appId: '1:851967648288:ios:967182600df12d35155245',
    messagingSenderId: '851967648288',
    projectId: 'aiot-nano',
    storageBucket: 'aiot-nano.appspot.com',
    iosBundleId: 'com.khoahockythuat.farmCareAi',
  );
}
