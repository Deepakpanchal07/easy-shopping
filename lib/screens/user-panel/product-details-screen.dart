import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/rating-controller.dart';
import 'package:e_commerce/models/cart-model.dart';
import 'package:e_commerce/models/product-model.dart';
import 'package:e_commerce/models/review-model.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/cart-controller.dart';
import 'cart-screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;

  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.find<CartController>();

    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: AppConstant.appTextColor, size: 32),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "Product Details",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        actions: [
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
                    : const SizedBox())
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              //   products images
              SizedBox(
                height: Get.height / 60,
              ),
              CarouselSlider(
                items: widget.productModel.productImages
                    .map((imgUrl) => ClipRect(
                          child: CachedNetworkImage(
                            imageUrl: imgUrl,
                            fit: BoxFit.fitHeight,
                            width: Get.width - 10,
                            placeholder: (context, url) => const ColoredBox(
                              color: Colors.white,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 1,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.productModel.productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              const Icon(Icons.favorite_outline),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Text(
                                "category: " + widget.productModel.categoryName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              )
                            ],
                          ),
                        ),
                      ),
                      // review
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: RatingBar.builder(
                              glow: false,
                              ignoreGestures: true,
                              initialRating: double.parse(
                                  calculateProductRatingController.averageRating
                                      .toString()),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ),
                          Text(
                            (calculateProductRatingController.averageRating
                                .toString()),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  widget.productModel.isSale == true &&
                                          widget.productModel.salePrice != ''
                                      ? Text(
                                          "PKR: ${widget.productModel.salePrice}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        )
                                      : Text(
                                          "PKR: " +
                                              widget.productModel.fullPrice,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // important for left alignment
                            children: [
                              const Text(
                                "Description:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.productModel.productDescription,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                child: Container(
                                  width: Get.width / 3.0,
                                  height: Get.height / 18,
                                  decoration: BoxDecoration(
                                    color: AppConstant.appSecondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextButton(
                                    child: const Text(
                                      "WhatsApp",
                                      style: TextStyle(
                                          color: AppConstant.appTextColor,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      sendMessageOnWhatsApp(
                                          productModel: widget.productModel);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 35.0,
                              ),
                              Material(
                                child: Container(
                                  width: Get.width / 3.0,
                                  height: Get.height / 18,
                                  decoration: BoxDecoration(
                                    color: AppConstant.appSecondaryColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextButton(
                                    child: isAdded
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : const Text(
                                            "Add To Cart",
                                            style: TextStyle(
                                                color: AppConstant.appTextColor,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    onPressed: () async {
                                      await checkProductExistence(
                                          uId: user!.uid);

                                      setState(() {
                                        isAdded = true;
                                      });

                                      Get.snackbar(
                                        "Success",
                                        "Product added to cart successfully!",
                                        backgroundColor:
                                            AppConstant.appMainColor,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 2),
                                      );

                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      setState(() {
                                        isAdded = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              //   review
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.productModel.productId)
                      .collection('review')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        child: Text("No review found!"),
                      );
                    }
                    if (snapshot.data != null) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          ReviewModel reviewModel = ReviewModel(
                              customerName: data['customerName'],
                              customerPhone: data['customerPhone'],
                              rating: data['rating'],
                              customerDeviceToken: data['customerDeviceToken'],
                              customerId: data['customerId'],
                              createdAt: data['createdAt'],
                              feedback: data['feedback']);

                          return Card(
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(reviewModel.customerName[0]),
                              ),
                              title: Text(reviewModel.customerName),
                              subtitle: Text(reviewModel.feedback),
                              trailing: Text(
                                reviewModel.rating,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> sendMessageOnWhatsApp(
      {required ProductModel productModel}) async {
    final number = "918816039384";
    final message = "👋 Hello, this is from Tazo!\n\n"
        "I'd like to know more about this product:\n\n"
        "📦 *${productModel.productName}*\n"
        "🆔 Product ID: *${productModel.productId}*\n\n"
        "Kindly share the details. Thanks! 🙌";

    final url =
        "whatsapp://send?phone=$number&text=${Uri.encodeComponent(message)}";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//    check product exits or not
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });

      print("Product Exists ");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        deliveryTime: widget.productModel.deliveryTime,
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
      );
      await documentReference.set(cartModel.toMap());

      print("Product Added");
    }
  }
}
