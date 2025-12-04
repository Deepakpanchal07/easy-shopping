import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/order-model.dart';
import 'package:e_commerce/screens/user-panel/main-screen.dart';
import 'package:e_commerce/services/generate-order-id-service.dart';
import 'package:e_commerce/services/send-notification-service.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'notification-service.dart';

void placeOrder(
    {required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerDeviceToken,
    required String customerAddress}) async {
  final user = FirebaseAuth.instance.currentUser;
  NotificationService notificationService = NotificationService();
  EasyLoading.show(status: "Please Wait...");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic?> data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
          categoryName: data['categoryName'],
          createdAt: DateTime.now(),
          categoryId: data['categoryId'],
          deliveryTime: data['deliveryTime'],
          fullPrice: data['fullPrice'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          productId: data['productId'],
          productImages: List<String>.from(data['productImages']),
          productName: data['productName'],
          salePrice: data['salePrice'],
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
          customerId: user.uid,
          customerName: customerName,
          customerPhone: customerPhone,
          status: false,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set({
            'uId': user.uid,
            'customerName': customerName,
            'customerPhone': customerPhone,
            'customerDeviceToken': customerDeviceToken,
            'customerAddress': customerAddress,
            'orderStatus': false,
            'createdAt': DateTime.now(),
          });

          //   upload Orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //         delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete Cart Products $cartModel.productId.toString()');
          });
        }
        //  save notification
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(user.uid)
            .collection('notifications')
            .doc()
            .set({
          'title': "Order Successfully Placed ${cartModel.productName}",
          'body': cartModel.productDescription,
          'isSeen': false,
          'createdAt': DateTime.now(),
          'image': cartModel.productImages,
          'fullPrice': cartModel.fullPrice,
          'salePrice': cartModel.salePrice,
          'isSale': cartModel.isSale,
          'productId': cartModel.productId,
        });
      }

      // sent notification:
      // await SendNotificationService.sendNotificationUsingApi(
      //     token:
      //         "eQkgzTwMSwmjKhBJ7WwOEr:APA91bG0OGlGt3Bxi7Q2XRN5OpIRRkkgGQKKkuFdvm7YliaV8eXlEl1qsSE05kBjGmGSpyMt4U_BNDLwQaD8ZOwdCGLv11wL0x1PnkrOw38ZdfZje0ScxaU",
      //     title: "Order Successfully Placed",
      //     body: "Notification body",
      //     data: {
      //       "Screen": "notification",
      //     },
      //     deviceToken: customerDeviceToken);

      print("Order Confirmed");
      Get.snackbar("Order Confirmed", "Thank You For Your Order",
          backgroundColor: AppConstant.appMainColor,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
      EasyLoading.dismiss();
      Get.off(() => MainScreen());
    } catch (e) {
      print("error $e");
    }
  }
}
