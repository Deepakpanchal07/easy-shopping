import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItemCount = 0.obs;

  String? get uId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    if (uId != null) {
      fetchCartCount();
    }
  }

  void fetchCartCount() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .snapshots()
        .listen((snapshot) {
      cartItemCount.value = snapshot.docs.length;
    });
  }
}
