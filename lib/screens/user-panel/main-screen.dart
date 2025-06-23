import 'package:e_commerce/screens/user-panel/all-categories-screen.dart';
import 'package:e_commerce/services/notification-service.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:e_commerce/widgets/banner-widget.dart';
import 'package:e_commerce/widgets/custom-drawer-widget.dart';
import 'package:e_commerce/widgets/heading-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart-controller.dart';
import '../../widgets/all-products-widget.dart';
import '../../widgets/category-widget.dart';
import '../../widgets/flash-sale-widget.dart';
import 'all-flash-sale-products.dart';
import 'all-products-screen.dart';
import 'cart-screen.dart';
import 'notification-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CartController cartController = Get.find<CartController>();

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: const TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
        actions: [
          // Notification icon
          GestureDetector(
            onTap: () => Get.to(() => const NotificationScreen()),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.notifications,
                size: 28,
                color: AppConstant.appTextColor,
              ),
            ),
          ),

          // Cart icon with badge
          GestureDetector(
            onTap: () => Get.to(() => const CartScreen()),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: AppConstant.appTextColor,
                  ),
                ),
                Obx(() => cartController.cartItemCount.value > 0
                    ? Positioned(
                        right: 10,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.cartItemCount.value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height / 90.0),

            // Banner
            const BannerWidget(),
            const SizedBox(height: 20),

            // Categories heading
            HeadingWidget(
              headingTitle: "Categories",
              headingSubTitle: "According To Your Budget",
              onTap: () => Get.to(() => const AllCategoriesScreen()),
              buttonText: "See More >",
            ),

            // Category list
            const CategoryWidget(),

            // Flash Sale heading
            HeadingWidget(
              headingTitle: "Flash Sale",
              headingSubTitle: "Don,t miss out!",
              onTap: () => Get.to(() => const AllFlashSaleProductScreen()),
              buttonText: "See More >",
            ),

            // Flash Sale items
            const FlashSaleWidget(),

            HeadingWidget(
              headingTitle: "All Products",
              headingSubTitle: "Check out the Latest",
              onTap: () => Get.to(() => const AllProductsScreen()),
              buttonText: "See More >",
            ),

            const AllProductsWdiget(),
          ],
        ),
      ),
    );
  }
}
