class OrderModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;

  OrderModel({
    required this.productId,
    required this.fullPrice,
    required this.productImages,
    required this.productTotalPrice,
    required this.productName,
    required this.salePrice,
    required this.isSale,
    required this.categoryName,
    required this.categoryId,
    required this.updatedAt,
    required this.createdAt,
    required this.productDescription,
    required this.deliveryTime,
    required this.customerAddress,
    required this.customerDeviceToken,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.productQuantity,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': customerId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productDescription': productDescription,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'customerPhone': customerPhone,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      productId: json['productId'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      productTotalPrice: json['productTotalPrice'],
      productName: json['productName'],
      salePrice: json['salePrice'],
      isSale: json['isSale'],
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      productDescription: json['productDescription'],
      deliveryTime: json['deliveryTime'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      productQuantity: json['productQuantity'],
      status: json['status'],
    );
  }
}
