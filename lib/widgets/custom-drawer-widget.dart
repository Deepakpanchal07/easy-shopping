import 'package:e_commerce/screens/auth-ui/contact-screen.dart';
import 'package:e_commerce/screens/user-panel/all-categories-screen.dart';
import 'package:e_commerce/screens/user-panel/all-order-screen.dart';
import 'package:e_commerce/screens/user-panel/all-products-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/auth-ui/welcome-screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: AppConstant.appSecondaryColor,
      child: Column(
        children: [
          // User Profile Section
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            decoration: BoxDecoration(
              color: AppConstant.appMainColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundColor: AppConstant.appMainColor,
                  child: Text(
                    "D",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Deepak",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Version 1.1.3",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(
            thickness: 1.5,
            color: Colors.grey,
            indent: 12,
            endIndent: 12,
          ),

          // Drawer List Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20.0),
              children: [
                customDrawerItem(
                  icon: Icons.home,
                  title: "Home",
                  onTap: () {
                    Get.to(() => AllCategoriesScreen());
                  },
                ),
                customDrawerItem(
                  icon: Icons.production_quantity_limits,
                  title: "Product",
                  onTap: () {
                    Get.to(() => AllProductsScreen());
                  },
                ),
                customDrawerItem(
                  icon: Icons.shopping_bag,
                  title: "Orders",
                  onTap: () {
                    Get.back();
                    Get.to(() => AllOrderScreen());
                  },
                ),
                customDrawerItem(
                  icon: Icons.help_center,
                  title: "Contact",
                  onTap: () {
                    Get.to(() => ContactScreen());
                  },
                ),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 1.5,
                  color: Colors.grey,
                  indent: 12,
                  endIndent: 12,
                ),

                // Logout Button
                customDrawerItem(
                  icon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    Get.defaultDialog(
                      title: "Logout",
                      middleText: "Are you sure you want to logout?",
                      textConfirm: "Yes",
                      textCancel: "No",
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        await _auth.signOut();
                        await _googleSignIn.signOut();
                        Get.offAll(() => WelcomeScreen());
                      },
                      onCancel: () {},
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Custom Drawer Item Widget
  Widget customDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minLeadingWidth: 10,
        titleAlignment: ListTileTitleAlignment.center,
        tileColor: AppConstant.appSecondaryColor.withOpacity(0.1),
        leading: Icon(icon, color: AppConstant.appTextColor, size: 26),
        title: Text(
          title,
          style: const TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: AppConstant.appTextColor),
      ),
    );
  }
}
