import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:platform/platform.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (const LocalPlatform().isAndroid) {
      return android;
    }
    throw UnsupportedError(
      'هذا التطبيق يدعم Android فقط. المنصة الحالية غير مدعومة.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-hNecPVPv1IBwCMrPc7gNUcFKeaDyZ_4',
    appId: '1:1062746634916:android:54dc1bb13b8be29dfe0431',
    messagingSenderId: '1062746634916',
    projectId: 'my-app-90810',
    storageBucket: 'my-app-90810.appspot.com',
  );
}