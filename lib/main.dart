import 'package:e_commerce/screens/auth-ui/splash-screen.dart';
import 'package:e_commerce/screens/auth-ui/welcome-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'controllers/cart-controller.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Register cart controller globally
  Get.put(CartController()).fetchCartCount();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  //  var getServerKey = GetServerKey();
  // String accessToken = await getServerKey.getServerKey();

  // print(accessToken);
  runApp(const MyApp());
}

// GetServerKey() {
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}
