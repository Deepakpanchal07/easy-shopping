import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/user-panel/single-category-products-screen.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../models/categories-model.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 32),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "All Categories",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorScreen("Error loading categories.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }

          if (snapshot.data!.docs.isEmpty) {
            return _buildErrorScreen("No categories found.");
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              mainAxisSpacing: 8, // Vertical spacing between items
              crossAxisSpacing: 8, // Horizontal spacing between items
              childAspectRatio: 1.19, // Aspect ratio for each item
            ),
            itemBuilder: (context, index) {
              CategoriesModel categoriesModel = CategoriesModel(
                categoryId: snapshot.data!.docs[index]['categoryId'],
                categoryImg: snapshot.data!.docs[index]['categoryImg'],
                categoryName: snapshot.data!.docs[index]['categoryName'],
                createdAt: snapshot.data!.docs[index]['createdAt'],
                updatedAt: snapshot.data!.docs[index]['updatedAt'],
              );

              return _buildCategoryCard(categoriesModel);
            },
            shrinkWrap: true,
            // Makes the grid view only take as much space as needed
            physics: NeverScrollableScrollPhysics(),
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
  Widget _buildCategoryCard(CategoriesModel categoriesModel) {
    return GestureDetector(
      onTap: () => Get.to(() => SingleCategoryProductsScreen(
            categoryId: categoriesModel.categoryId,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: FillImageCard(
            borderRadius: 20.0,
            width: Get.width / 2.3,
            heightImage: Get.height / 10,
            imageProvider:
                CachedNetworkImageProvider(categoriesModel.categoryImg),
            title: Center(
              child: Text(
                categoriesModel.categoryName,
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
