import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/material.dart';

class CartInfoScreen extends StatelessWidget {
  const CartInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: AppConstant.appTextColor, size: 28),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
        title: const Text(
          'Cart Info',
          style: TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              '🛒 How Your Cart Works',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            infoCard(
              icon: Icons.add_shopping_cart,
              title: 'Adding Products',
              description:
                  'Tap on any product to view details and use "Add to Cart" to add it.',
            ),
            infoCard(
              icon: Icons.tune,
              title: 'Managing Quantity',
              description:
                  'Use the "-" and "+" buttons in your cart to adjust quantity. Price updates instantly.',
            ),
            infoCard(
              icon: Icons.delete_outline,
              title: 'Removing Products',
              description:
                  'Swipe left on a product in your cart to reveal "Delete" and remove it.',
            ),
            infoCard(
              icon: Icons.payment,
              title: 'Checkout',
              description:
                  'After confirming your cart, tap "Checkout" and follow steps to place your order.',
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.support_agent, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'For any issues, feel free to contact our support team anytime.',
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget infoCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppConstant.appMainColor.withOpacity(0.1),
              child: Icon(icon, color: AppConstant.appMainColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description,
                      style: const TextStyle(fontSize: 16, height: 1.4)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
