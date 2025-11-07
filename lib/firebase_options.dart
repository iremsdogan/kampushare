import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB_o-6a_vVDNeqixem7W0K86NahIkH9oyw',
    appId: '1:502078547435:web:3dc4f75cfe6521a81725ae',
    messagingSenderId: '502078547435',
    projectId: 'kampushare0',
    authDomain: 'kampushare0.firebaseapp.com',
    storageBucket: 'kampushare0.firebasestorage.app',
    measurementId: 'G-LMX8SB093H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCu_sfgN9ykQvdx-50tJnxlOrCPzXnY6qE',
    appId: '1:502078547435:android:bf76c07c058c906b1725ae',
    messagingSenderId: '502078547435',
    projectId: 'kampushare0',
    storageBucket: 'kampushare0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYbm_chvbfMm_lWdooWvC2nX_eEmytN0A',
    appId: '1:502078547435:ios:58d803695855cca81725ae',
    messagingSenderId: '502078547435',
    projectId: 'kampushare0',
    storageBucket: 'kampushare0.firebasestorage.app',
    iosBundleId: 'com.example.kampushare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYbm_chvbfMm_lWdooWvC2nX_eEmytN0A',
    appId: '1:502078547435:ios:58d803695855cca81725ae',
    messagingSenderId: '502078547435',
    projectId: 'kampushare0',
    storageBucket: 'kampushare0.firebasestorage.app',
    iosBundleId: 'com.example.kampushare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB_o-6a_vVDNeqixem7W0K86NahIkH9oyw',
    appId: '1:502078547435:web:1893deb79ed344901725ae',
    messagingSenderId: '502078547435',
    projectId: 'kampushare0',
    authDomain: 'kampushare0.firebaseapp.com',
    storageBucket: 'kampushare0.firebasestorage.app',
    measurementId: 'G-PXFM21XZSS',
  );
}
