class ProductModel {
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
  final List productImagesText;

  ProductModel(
      {required this.categoryName,
      required this.createdAt,
      required this.categoryId,
      required this.deliveryTime,
      required this.fullPrice,
      required this.isSale,
      required this.productDescription,
      required this.productId,
      required this.productImages,
      required this.productName,
      required this.salePrice,
      required this.productImagesText});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'salePrice': salePrice,
      'productImagesText': productImagesText,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      categoryName: json['categoryName'],
      createdAt: json['createdAT'],
      categoryId: json['categoryId'],
      deliveryTime: json['deliveryTime'],
      fullPrice: json['fullPrice'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      productId: json['productId'],
      productImages: json['productImages'],
      productName: json['productName'],
      salePrice: json['salePrice'],
      productImagesText: json['productImagesText'],
    );
  }
}
