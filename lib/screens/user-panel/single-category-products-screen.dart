import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/product-model.dart';
import 'package:e_commerce/screens/user-panel/product-details-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleCategoryProductsScreen extends StatefulWidget {
  String categoryId;

  SingleCategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<SingleCategoryProductsScreen> createState() =>
      _SingleCategoryProductsScreenState();
}

class _SingleCategoryProductsScreenState
    extends State<SingleCategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Products",
          style: const TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('products')
              .where('categoryId', isEqualTo: widget.categoryId)
              .get(),
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
                child: Text("No Category Found!"),
              );
            }
            if (snapshot.data != null) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.0),
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
                    productImages:
                        List<String>.from(productData['productImages']),
                    productName: productData['productName'],
                    salePrice: productData['salePrice'],
                    // Add productImageTexts as a list
                    productImagesText:
                        List<String>.from(productData['productImagesText']),
                  );

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetailsScreen(productModel: productModel)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          // Wrap Column with SingleChildScrollView
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 👇 Images Row
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                    productModel.productImages.length,
                                    (imgIndex) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: productModel
                                              .productImages[imgIndex],
                                          placeholder: (context, url) =>
                                              CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          width: (Get.width - 40) / 2,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        productModel
                                            .productImagesText[imgIndex],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              // SizedBox(height: 8),
                              // Text(
                              //   productModel.productName,
                              //   style: TextStyle(
                              //       fontSize: 16, fontWeight: FontWeight.bold),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }
}
