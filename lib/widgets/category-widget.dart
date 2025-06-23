import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/categories-model.dart';
import 'package:e_commerce/screens/user-panel/single-category-products-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
              child: Text("No Catergory Found!"),
            );
          }
          if (snapshot.data != null) {
            return Container(
              height: Get.height / 5.5,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    categoryImg: snapshot.data!.docs[index]['categoryImg'],
                    categoryName: snapshot.data!.docs[index]['categoryName'],
                    createdAt: snapshot.data!.docs[index]['createdAt'],
                    updatedAt: snapshot.data!.docs[index]['updatedAt'],
                  );
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(
                          () => SingleCategoryProductsScreen(
                            categoryId: categoriesModel.categoryId,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 20.0,
                              width: Get.width / 4.0,
                              heightImage: Get.height / 12,
                              imageProvider: CachedNetworkImageProvider(
                                categoriesModel.categoryImg,
                              ),
                              title: Center(
                                child: Text(
                                  categoriesModel.categoryName,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              footer: Center(
                                  child: Row(
                                mainAxisSize: MainAxisSize.min,
                              )),
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
