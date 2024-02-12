import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String? productName;
  final List<String>? imageUrls;
  final String? category;
  final String? brand;
  final int? regularPrice;
  final int? salesPrice;
  final String? taxStatus;
  final double? taxPercentage;
  final String? mainCategory;
  final String? subCategory;
  final String? description;
  final DateTime? scheduleDate;
  final String? sku;
  final bool? manageInventory;
  final int? soh;
  final int? reOrderLevel;
  final bool? chargeShipping;
  final double? shippingCharge;
  final List<String>? sizeList;

  Product({
    required this.id,
    this.productName,
    this.imageUrls,
    this.category,
    this.brand,
    this.regularPrice,
    this.salesPrice,
    this.taxStatus,
    this.taxPercentage,
    this.mainCategory,
    this.subCategory,
    this.description,
    this.scheduleDate,
    this.sku,
    this.manageInventory,
    this.soh,
    this.reOrderLevel,
    this.chargeShipping,
    this.shippingCharge,
    this.sizeList,
  });

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id'] as String? ?? '', // Corrected the key to 'id'
      productName: json['productName'] as String? ?? '',
      imageUrls: List<String>.from(json['imageUrls'] as List<dynamic>? ?? []),
      category: json['category'] as String? ?? '',
      brand: json['brand'] as String?,
      regularPrice: (json['regularPrice'] as num?)?.toInt() ?? 0,
      salesPrice: (json['salesPrice'] as num?)?.toInt(),
      taxStatus: json['taxStatus'] as String? ?? '',
      taxPercentage: (json['taxValue'] as num?)?.toDouble(),
      mainCategory: json['mainCategory'] as String?,
      subCategory: json['subCategory'] as String?,
      description: json['description'] as String?,
      scheduleDate: (json['scheduleDate'] as Timestamp?)?.toDate(),
      sku: json['sku'] as String?,
      manageInventory: json['manageInventory'] as bool?,
      soh: json['soh'] as int?,
      reOrderLevel: json['reOrderLevel'] as int?,
      chargeShipping: json['chargeShipping'] as bool?,
      shippingCharge: json['shippingCharge'] as double?,
      sizeList: List<String>.from(json['size'] as List<dynamic>? ?? []),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id':id,
      'brand': brand,
      'productName': productName,
      'regularPrice': regularPrice,
      'salesPrice': salesPrice,
      'taxStatus': taxStatus,
      'taxPercentage': taxPercentage,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'description': description,
      'scheduleDate': scheduleDate,
      'sku': sku,
      'manageInventory': manageInventory,
      'soh': soh,
      'reOrderLevel': reOrderLevel,
      'chargeShipping': chargeShipping,
      'shippingCharge': shippingCharge,
      'sizeList': sizeList,
      // Add other fields as needed
    };
  }
}

productQuery({category}) {
  Query query = FirebaseFirestore.instance.collection('products').where('approved', isEqualTo: true);

  if (category != null && category.isNotEmpty) {
    query = query.where('category', isEqualTo: category);
  }

  return query.withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );
}

