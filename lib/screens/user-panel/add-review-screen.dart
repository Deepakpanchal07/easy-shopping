import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/order-model.dart';
import 'package:e_commerce/models/review-model.dart';
import 'package:e_commerce/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewScreen extends StatefulWidget {
  final OrderModel orderModel;

  const AddReviewScreen({super.key, required this.orderModel});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController feedbackController = TextEditingController();
  double productRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "Add Review",
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Add Your Rating And Review",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                productRating = rating;
                print(productRating);
                setState(() {});
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Feedback",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: feedbackController,
              decoration: InputDecoration(
                label: Text(
                  "Share Your Feedback",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: "Please Wait...");
                  String feedback = feedbackController.text.trim();
                  User? user = FirebaseAuth.instance.currentUser;
                  // print(productRating);
                  // print(feedback);

                  ReviewModel reviewModel = ReviewModel(
                    customerName: widget.orderModel.customerName,
                    customerPhone: widget.orderModel.customerPhone,
                    rating: productRating.toString(),
                    customerDeviceToken: widget.orderModel.customerDeviceToken,
                    customerId: widget.orderModel.customerId,
                    createdAt: DateTime.now(),
                    feedback: feedback,
                  );

                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.orderModel.productId)
                      .collection('review')
                      .doc(user!.uid)
                      .set(reviewModel.toMap());
                  EasyLoading.dismiss();
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}
