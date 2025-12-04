import 'dart:ui';

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
      body: Stack(
        children: [
          /// 🎯 Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff8E0E00),
                  Color(0xffFF512F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// 🎉 Confetti Animation
          Positioned.fill(
            child: Lottie.asset(
              'assets/images/Confetti.json',
              fit: BoxFit.cover,
            ),
          ),

          /// ✅ Dark Glass Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),

          /// ✅ Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// 🛒 Shopping Animation
                SizedBox(
                  height: 260,
                  child:
                  Lottie.asset('assets/images/shopping cart.json'),
                ),

                const SizedBox(height: 15),

                /// 🎯 Title
                const Text(
                  "Welcome to TIVY",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                /// ✅ Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "India’s smartest shopping app for best deals and premium products 🚀",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// ✅ Glassmorphic Button Section
                clipGlassContainer(
                  child: Column(
                    children: [
                      /// ✅ Google Sign In Button
                      buildButton(
                        icon: Image.asset(
                          'assets/images/google.png',
                          width: 24,
                        ),
                        text: "Continue with Google",
                        onTap: () {
                          _googleSignInController.signInWithGoogle();
                        },
                      ),

                      const SizedBox(height: 15),

                      /// ✅ Email Sign In Button
                      buildButton(
                        icon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                        text: "Continue with Email",
                        onTap: () {
                          Get.to(() => const SignInScreen());
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// ✅ Footer Text
                const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "Happy Shopping ✨",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Glass Container
  Widget clipGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white24,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// ✅ Custom Button
  Widget buildButton(
      {required Widget icon,
        required String text,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: const LinearGradient(
            colors: [
              Color(0xff00c6ff),
              Color(0xff0072ff),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
