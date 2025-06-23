import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/user-panel/product-details-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../models/product-model.dart';
import '../../utils/app-constant.dart';

class AllFlashSaleProductScreen extends StatefulWidget {
  const AllFlashSaleProductScreen({super.key});

  @override
  State<AllFlashSaleProductScreen> createState() =>
      _AllFlashSaleProductScreenState();
}

class _AllFlashSaleProductScreenState extends State<AllFlashSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 32),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "All Flash Sale Products",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorScreen("Error loading categories.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }

          if (snapshot.data!.docs.isEmpty) {
            return _buildErrorScreen("No Products found.");
          }

          // Use GridView.builder to create a scrollable grid
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              mainAxisSpacing: 8, // Vertical spacing between items
              crossAxisSpacing: 8, // Horizontal spacing between items
              childAspectRatio: 1.19, // Aspect ratio for each item
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              ProductModel productModel = ProductModel(
                categoryName: productData['categoryName'],
                createdAt: productData['createdAt'],
                categoryId: productData['categoryId'],
                deliveryTime: productData['deliveryTime'],
                fullPrice: productData['fullPrice'],
                isSale: productData['isSale'],
                productDescription: productData['productDescription'],
                productId: productData['productId'],
                productImages: productData['productImages'],
                productName: productData['productName'],
                salePrice: productData['salePrice'],
                productImagesText: ['productImagesText'],
              );
              // CategoriesModel categoriesModel = CategoriesModel(
              //   categoryId: snapshot.data!.docs[index]['categoryId'],
              //   categoryImg: snapshot.data!.docs[index]['categoryImg'],
              //   categoryName: snapshot.data!.docs[index]['categoryName'],
              //   createdAt: snapshot.data!.docs[index]['createdAt'],
              //   updatedAt: snapshot.data!.docs[index]['updatedAt'],
              // );

              return _buildCategoryCard(productModel);
            },
            shrinkWrap: true,
            // Makes the grid view only take as much space as needed
            physics:
                NeverScrollableScrollPhysics(), // Prevents double scrolling (because the parent is scrollable)
          );
        },
      ),
    );
  }

  // Loading indicator widget
  Widget _buildLoadingIndicator() {
    return Container(
      height: Get.height / 5,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  // Error screen widget
  Widget _buildErrorScreen(String message) {
    return Center(
      child: Text(message),
    );
  }

  // Category card widget
  Widget _buildCategoryCard(ProductModel productModel) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => ProductDetailsScreen(productModel: productModel)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: FillImageCard(
            borderRadius: 20.0,
            width: Get.width / 2.3,
            heightImage: Get.height / 10,
            imageProvider: CachedNetworkImageProvider(
              productModel.productImages[0],
            ),
            title: Center(
              child: Text(
                productModel.productName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            footer: Center(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            )),
          ),
        ),
      ),
    );
  }
}
