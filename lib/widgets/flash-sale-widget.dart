import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/product-model.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-panel/product-details-screen.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text("No Products Found!"),
            );
          }
          if (snapshot.data != null) {
            return Container(
              height: Get.height / 4.5,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() =>
                            ProductDetailsScreen(productModel: productModel)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width / 3.0,
                              heightImage: Get.height / 12,
                              imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0],
                              ),
                              title: Center(
                                child: Text(
                                  productModel.productName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              footer: Row(
                                children: [
                                  Text(
                                    "₹ ${productModel.salePrice}",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    " ${productModel.fullPrice}",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: AppConstant.appSecondaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
          return Container();
        });
  }
}
