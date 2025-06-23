import 'package:e_commerce/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor, size: 32),
        backgroundColor: AppConstant.appSecondaryColor,
        centerTitle: true,
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/images/contactus.json',
              height: 200,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: nameController,
              hint: "Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              hint: "Phone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: messageController,
              hint: "Your Message",
              icon: Icons.message,
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: Get.width * 0.6,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appSecondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      messageController.text.isEmpty) {
                    Get.snackbar(
                      "Incomplete",
                      "Please fill all fields",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppConstant.appSecondaryColor,
                      colorText: AppConstant.appTextColor,
                    );
                  } else {
                    Get.snackbar(
                      "Thanks for contacting us!",
                      "You will get a reply within 2 hours.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppConstant.appSecondaryColor,
                      colorText: AppConstant.appTextColor,
                    );
                    // Clear form
                    nameController.clear();
                    emailController.clear();
                    phoneController.clear();
                    messageController.clear();
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: AppConstant.appTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      cursorColor: AppConstant.appSecondaryColor,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppConstant.appSecondaryColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
