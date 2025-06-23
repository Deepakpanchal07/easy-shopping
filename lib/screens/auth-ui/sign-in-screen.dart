import 'package:e_commerce/controllers/sign-in-controller.dart';
import 'package:e_commerce/screens/admin-panel/admin-main-screen.dart';
import 'package:e_commerce/screens/auth-ui/forget-password-screen.dart';
import 'package:e_commerce/screens/auth-ui/sign-up-screen.dart';
import 'package:e_commerce/screens/user-panel/main-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/get-user-data-controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appSecondaryColor,
            iconTheme:
                const IconThemeData(color: AppConstant.appTextColor, size: 35),
            centerTitle: true,
            title: const Text(
              "Sign In",
              style: TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isKeyboardVisible
                      ? const Text("Welcome Friends")
                      : Center(
                          child: Lottie.asset(
                            'assets/images/signin.json', // Corrected spelling
                            height: 250,
                          ),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          contentPadding:
                              const EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Obx(
                        () => TextFormField(
                          controller: userPassword,
                          obscureText: signInController.isPasswordVisible.value,
                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signInController.isPasswordVisible.toggle();
                              },
                              child: signInController.isPasswordVisible.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const ForgetPasswordScreen());
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Material(
                      child: Container(
                        width: Get.width / 2,
                        height: Get.height / 18,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(
                              color: AppConstant.appTextColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            String email = userEmail.text.trim();
                            String password = userPassword.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please Enter All Details....",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            } else {
                              UserCredential? userCredential =
                                  await signInController.signInMethod(
                                      email, password);

                              var userdata = await getUserDataController
                                  .getUserData(userCredential!.user!.uid);

                              if (userCredential.user!.emailVerified) {
                                //
                                if (userdata[0]['isAdmin'] == true) {
                                  Get.snackbar(
                                    "Success Admin Login ",
                                    "Login Successful",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                  Get.offAll(() => const AdminMainScreen());
                                } else {
                                  Get.snackbar(
                                    "Success User Login ",
                                    "Login Successful",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor,
                                  );
                                  Get.offAll(() => const MainScreen());
                                }
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Please Verify Your Email before Login....",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account? ",
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.offAll(() => const SignUpScreen()),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
