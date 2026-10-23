import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_store/app/di/injection.dart';
import 'package:furniture_store/core/logging/app_logger.dart';
import 'package:furniture_store/firebase_options.dart';

/// Run with `--dart-define=USE_EMULATOR=true` to use the local Firebase
/// emulators (see README). `EMULATOR_HOST` is `10.0.2.2` on an Android
/// emulator.
const _useEmulator = bool.fromEnvironment('USE_EMULATOR');
const _emulatorHost = String.fromEnvironment(
  'EMULATOR_HOST',
  defaultValue: 'localhost',
);

/// Starts everything the app needs before the first frame: error handlers,
/// Firebase and the dependency container.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Install the error handlers first so that startup errors are logged too.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppLogger.error('Flutter error', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Uncaught error', error, stack);
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (_useEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator(_emulatorHost, 8080);
    await FirebaseAuth.instance.useAuthEmulator(_emulatorHost, 9099);
    debugPrint('Using Firebase emulators on $_emulatorHost');
  }

  await setupDependencies();
}
