import 'package:e_commerce/controllers/google-sign-in-controller.dart';
import 'package:e_commerce/screens/auth-ui/sign-in-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "🎉 Welcome to Tivy!",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          // Background Lottie
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Lottie.asset(
              'assets/images/background.json',
              fit: BoxFit.cover,
            ),
          ),

          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.black.withOpacity(0.4),
          ),
          Column(
            children: [
              SizedBox(
                height: 250,
                width: 2000,
                child: Lottie.asset('assets/images/welcomes.json'),
              ),

              // Heading Text
              const Text(
                "Happy Shopping 🎁",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // Sub text
              const Text(
                "Get amazing products and deals only on Tivy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),
              Container(
                width: 275,
                height: 55,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 26,
                    height: 26,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 275,
                height: 55,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.email,
                    size: 28.0,
                    color: AppConstant.appTextColor,
                  ),
                  label: const Text(
                    "Sign in with Email",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => const SignInScreen());
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Footer Text
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    "Enjoy your shopping ✌️",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
