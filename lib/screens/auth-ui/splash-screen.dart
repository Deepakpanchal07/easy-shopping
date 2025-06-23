import 'dart:async';

import 'package:e_commerce/controllers/get-user-data-controller.dart';
import 'package:e_commerce/screens/admin-panel/admin-main-screen.dart';
import 'package:e_commerce/screens/auth-ui/welcome-screen.dart';
import 'package:e_commerce/screens/user-panel/main-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
        Get.offAll(() => const AdminMainScreen());
      } else {
        Get.offAll(() => const MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset(
            'assets/images/splash.json',
            fit: BoxFit.cover,
          ),
          //  powered by text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                AppConstant.appPoweredBy,
                style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
