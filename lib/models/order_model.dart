import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clickncart/models/product_model.dart';

class LocalOrder {
  late String orderId;
  late String buyerId;
  late List<Product> products;
  late String paymentId;
  late String totalAmount;
  late DateTime timestamp;
  late DateTime orderDate;
  late List<String> productNames;

  // Named constructor
  LocalOrder({
    required this.orderId,
    required this.buyerId,
    required this.products,
    required this.paymentId,
    required this.totalAmount,
    required this.timestamp,
    required this.orderDate,
    required this.productNames,
  });

  // Factory method 'fromFirestore' to convert Firestore document to Order object
  factory LocalOrder.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<Product> products = (data['products'] as List<dynamic>? ?? [])
        .map((item) => Product.fromJson(item))
        .toList();

    List<String> productNames = products
        .where((product) => product.productName != null)
        .map((product) => product.productName!)
        .toList();

    return LocalOrder(
      orderId: doc.id,
      buyerId: data['buyerId'] ?? '',
      products: products,
      paymentId: data['paymentId'] ?? '',
      totalAmount: data['totalAmount'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      productNames: productNames,
    );
  }

}
