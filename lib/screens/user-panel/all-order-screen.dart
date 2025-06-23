import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/cart-price-controller.dart';
import 'package:e_commerce/models/order-model.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add-review-screen.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductsPriceController productsPriceController =
      Get.put(ProductsPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "All Orders",
          style: const TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(user!.uid)
              .collection('confirmOrders')
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
                  OrderModel orderModel = OrderModel(
                    categoryName: productData['categoryName'],
                    createdAt: productData['createdAt'],
                    categoryId: productData['categoryId'],
                    fullPrice: productData['fullPrice'],
                    productDescription: productData['productDescription'],
                    productId: productData['productId'],
                    productImages:
                        List<String>.from(productData['productImages']),
                    productName: productData['productName'],
                    salePrice: productData['salePrice'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                    customerAddress: productData['customerAddress'],
                    customerDeviceToken: productData['customerDeviceToken'],
                    customerId: productData['customerId'],
                    customerName: productData['customerName'],
                    customerPhone: productData['customerPhone'],
                    status: productData['status'],
                    deliveryTime: '',
                    isSale: false,
                  );

                  // calculate the price
                  productsPriceController.fetchProductPrice();
                  return Card(
                    elevation: 5,
                    color: AppConstant.appTextColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        backgroundImage:
                            NetworkImage(orderModel.productImages[0]),
                      ),
                      title: Text(
                        orderModel.productName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            orderModel.productTotalPrice.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          orderModel.status != true
                              ? Text(
                                  "Pending..",
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text(
                                  "Delivered",
                                  style: TextStyle(color: Colors.red),
                                )
                        ],
                      ),
                      trailing: orderModel.status == true
                          ? ElevatedButton(
                              onPressed: () => Get.to(() => AddReviewScreen(
                                    orderModel: orderModel,
                                  )),
                              child: Text("Review"))
                          : SizedBox.shrink(),
                    ),
                  );
                },
              ));
            }

            return Container();
          }),
    );
  }
}
