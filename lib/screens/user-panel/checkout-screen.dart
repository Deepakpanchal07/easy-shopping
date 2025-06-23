import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/cart-price-controller.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../controllers/get-customer-device-token-controller.dart';
import '../../models/cart-model.dart';
import '../../services/place-order-service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductsPriceController productsPriceController =
      Get.put(ProductsPriceController());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? customerToken;
  String? name;
  String? phone;
  String? address;

  Razorpay _razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Checkout Screen",
          style: const TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
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
                      color: Colors.white12,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              cartModel.productTotalPrice.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                " Total ${productsPriceController.totalPrice.value.toStringAsFixed(1)} : PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 20,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: const Text(
                      "Confirmed Order",
                      style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      showCustomBottomSheet();
                      // GetServerKey getServerKey = GetServerKey();
                      // String accessToken =
                      //     await getServerKey.getServerKeyToken();
                      // print(accessToken);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              spreadRadius: 3,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Text(
                  "Delivery Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.appMainColor,
                  ),
                ),
                SizedBox(height: 25),

                // Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  ),
                ),
                SizedBox(height: 18),

                // Phone
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  ),
                ),
                SizedBox(height: 18),

                // Address
                TextFormField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    labelText: 'Complete Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  ),
                ),
                SizedBox(height: 28),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: AppConstant.appMainColor.withOpacity(0.4),
                    ),
                    icon:
                        Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          addressController.text.isNotEmpty) {
                        String name = nameController.text.trim();
                        String phone = phoneController.text.trim();
                        String address = addressController.text.trim();

                        String customerToken = await getCustomerDeviceToken();

                        var options = {
                          'key': 'rzp_test_VtaTcLC7GOx5gq',
                          'amount': 1000,
                          'currency': 'USD',
                          'name': 'Acme Corp.',
                          'description': 'Fine T-Shirt',
                          'prefill': {
                            'contact': phone,
                            'email': 'test@razorpay.com'
                          }
                        };

                        _razorpay.open(options);
                      } else {
                        Get.snackbar(
                          "Incomplete Details",
                          "Please fill all fields before placing order.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16),
                        );
                      }
                    },
                    label: Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 8,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // place order service
    placeOrder(
      context: context,
      customerName: name!,
      customerPhone: phone!,
      customerAddress: address!,
      customerDeviceToken: customerToken!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }
}
