import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/cart-price-controller.dart';
import 'package:e_commerce/screens/user-panel/checkout-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../models/cart-model.dart';
import 'cart-information.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductsPriceController productsPriceController =
      Get.put(ProductsPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add to Cart',
          style: TextStyle(
              color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 35),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline), // ? icon
            color: AppConstant.appTextColor,
            onPressed: () {
              Get.to(() => const CartInfoScreen());
            },
            tooltip: 'Cart Information',
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(user!.uid)
              .collection('cartOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No Products Found!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              );
            }
            if (snapshot.data != null) {
              return Container(
                  child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
                    categoryName: productData['categoryName'],
                    createdAt: productData['createdAt'],
                    categoryId: productData['categoryId'],
                    deliveryTime: productData['deliveryTime'],
                    fullPrice: productData['fullPrice'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    productId: productData['productId'],
                    productImages:
                        List<String>.from(productData['productImages']),
                    productName: productData['productName'],
                    salePrice: productData['salePrice'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: productData['productTotalPrice'],
                  );

                  // calculate the price
                  productsPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print("Deleted");

                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(
                          cartModel.productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            // Price text first, wrapped in Expanded to push rest to right
                            Expanded(
                              child: Text(
                                "₹  ${cartModel.productTotalPrice.toString()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppConstant.appMainColor,
                                ),
                              ),
                            ),

                            // Quantity controls - minus, quantity, plus
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 1) {
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productId)
                                      .update({
                                    'productQuantity':
                                        cartModel.productQuantity - 1,
                                    'productTotalPrice':
                                        (double.parse(cartModel.fullPrice) *
                                            (cartModel.productQuantity - 1))
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: AppConstant.appMainColor,
                                radius: 14.0,
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppConstant.appTextColor),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width / 20.0),
                            Text(
                              cartModel.productQuantity.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: Get.width / 20.0),
                            GestureDetector(
                              onTap: () async {
                                if (cartModel.productQuantity > 0) {
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productId)
                                      .update({
                                    'productQuantity':
                                        cartModel.productQuantity + 1,
                                    'productTotalPrice':
                                        double.parse(cartModel.fullPrice) +
                                            double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity)
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: AppConstant.appMainColor,
                                radius: 14.0,
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppConstant.appTextColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            }

            return Container();
          }),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        // thoda horizontal padding for better spacing
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                "Total  :  ₹ ${productsPriceController.totalPrice.value.toStringAsFixed(1)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppConstant.appMainColor,
                ),
              ),
            ),
            Material(
              child: Container(
                width: Get.width / 2.5,
                height: Get.height / 20,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton(
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => CheckOutScreen());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
