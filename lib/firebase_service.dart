
import 'package:clickncart/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/order_model.dart';
import 'models/product_model.dart';


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection(
      'categorise');
  CollectionReference mainCategorise = FirebaseFirestore.instance.collection(
      'mainCategorise');
  CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategorise');
  CollectionReference sellers = FirebaseFirestore.instance.collection('sellers');
  CollectionReference products = FirebaseFirestore.instance.collection('products');



  String formatedNumber(number){
    var f = NumberFormat('#,##,###');
    String formattedNumber = f.format(number);
    return formattedNumber;
  }




  Future<DocumentSnapshot> getSellerById(String sellerId) async {
    try {
      return await _firestore.collection('sellers').doc(sellerId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching seller data by ID: $error");
      throw error;
    }
  }

  Future<DocumentSnapshot> getProductById(String productId) async {
    try {
      return await _firestore.collection('products').doc(productId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching product data by ID: $error");
      throw error;
    }
  }



  String formatedDate(DateTime date){
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm aa');
    var outputDate = outputFormat.format(date);
    return outputDate;
  }


  Widget formField({String? label, TextInputType? inputType, void Function(String)? onChanged, int? minLine,int? maxLine}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }
  scaffold(context, message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,),
      action: SnackBarAction(
        label: 'OK',
        onPressed: (){
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }


  Future<List<Product>> getCartItems(String userId) async {
    try {
      List<Product> cartItems = [];

      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('buyers').doc(userId).collection('cart').get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Product product = Product.fromJson(data);
        cartItems.add(product);
      }

      return cartItems;
    } catch (error) {
      // Handle errors
      print('Error fetching cart items: $error');
      throw error;
    }
  }

  Future<void> addToCart(String buyerId, Product product) async {
    try {
      // Check if the product is already in the cart
      bool isProductInCart = await isProductAlreadyInCart(buyerId, product.id);

      if (isProductInCart) {
        print('Product is already in the cart. ProductId: ${product.id}');
        return; // Do not add the product again
      }

      // Log additional information for debugging
      print('Adding product to cart:');
      print('Buyer ID: $buyerId');
      print('Product ID: ${product.id}');
      print('Product Name: ${product.productName}');
      print('Product Price: ${product.salesPrice ?? product.regularPrice}');

      // Assuming 'cart' is the name of the collection storing user carts
      // and 'items' is the name of the subcollection containing cart items
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(buyerId)
          .collection('cart')
          .doc(product.id) // Assuming each product has a unique ID
          .set(product.toJson());

      print('Product added to cart successfully');
    } catch (e) {
      print('Error adding product to cart: $e');
      throw e;
    }
  }



// Helper method to check if a product is already in the cart
  Future<bool> isProductAlreadyInCart(String buyerId, String productId) async {
    try {
      // Check if the product already exists in the cart
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('buyers')
          .doc(buyerId)
          .collection('cart')
          .doc(productId)
          .get();

      return documentSnapshot.exists;
    } catch (e) {
      // Handle errors
      print('Error checking if product is in cart: $e');
      throw e;
    }
  }





  // Inside the FirebaseService class
  Future<void> removeFromCart(String userId, Product product) async {
    try {
      // Assuming 'cart' is the name of the collection storing user carts
      // and 'items' is the name of the subcollection containing cart items
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .collection('cart')
          .doc(product.id) // Assuming each product has a unique ID
          .delete();

      print('Product removed from cart: ${product.productName}');
    } catch (e) {
      // Handle errors
      print('Error removing product from cart: $e');
      throw e;
    }
  }


  Future<void> createOrder({
    required String buyerId,
    required List<Product> products,
    required String paymentId,
    required String totalAmount,
    required String sellerId,
    required String status,
  }) async {
    try {
      // Assuming 'orders' is the name of the collection storing orders
      CollectionReference ordersCollection = _firestore.collection('orders');

      // Convert products to a list of maps
      List<Map<String, dynamic>> productsData =
      products.map((product) => product.toJson()).toList();

      // Create an order document
      await ordersCollection.add({
        'buyerId': buyerId,
        'products': productsData,
        'paymentId': paymentId,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'sellerId': sellerId,
        'status':status,
      });

      print('Order created successfully');
    } catch (e) {
      print('Error creating order: $e');
      throw e;
    }
  }

  Future<List<LocalOrder>> getUserOrders(String userId) async {
    try {
      // Implement logic to fetch user orders from Firebase using the provided userId
      // Example: Query the 'orders' collection where 'buyerId' matches
      // Return a List<Order>

      // For example:
      QuerySnapshot orderSnapshot =
      await _firestore.collection('orders').where('buyerId', isEqualTo: userId).get();
      List<LocalOrder> userOrders =
      orderSnapshot.docs.map((doc) => LocalOrder.fromFirestore(doc)).toList();
      return userOrders;

      // Replace the above logic with your actual implementation
      // throw UnimplementedError('getUserOrders method not implemented');
    } catch (e) {
      print('Error fetching user orders: $e');
      throw e;
    }
  }


  Future<void> deleteOrder(String orderId) async {
    try {
      // Implement the logic to delete the order from Firebase
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<DocumentSnapshot> getBuyerById(String buyerId) async {
    try {
      return await _firestore.collection('buyers').doc(buyerId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching buyer data by ID: $error");
      throw error;
    }
  }

  Future<Map<String, dynamic>?> getBuyerDetailsById(String buyerId) async {
    try {
      DocumentSnapshot buyerSnapshot =
      await _firestore.collection('buyers').doc(buyerId).get();

      if (buyerSnapshot.exists) {
        return buyerSnapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching buyer details by ID: $error");
      throw error;
    }
  }

// Inside the FirebaseService class
  Future<List<Map<String, dynamic>>> getSellerSoldProducts(String sellerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      List<Map<String, dynamic>> soldProducts = [];

      for (var doc in querySnapshot.docs) {
        List<Map<String, dynamic>> products =
        List<Map<String, dynamic>>.from(doc['products']);

        for (var productData in products) {
          if (productData.containsKey('productName')) {
            soldProducts.add({
              'productName': productData['productName'],
              'sellerId': productData['sellerId'],
              'buyerId': doc['buyerId'], // Fetch buyerId from the order document
              'salesPrice': productData['salesPrice'],
              'status': doc['status'],
              // Add more fields as needed
            });
          }
        }
      }

      print('Number of sold products found: ${soldProducts.length}');
      for (var product in soldProducts) {
        print('Product Name: ${product['productName']}');
        print('Sales Price: ${product['salesPrice']}');
        print('Buyer ID: ${product['buyerId']}');
        // Add more fields as needed
      }

      return soldProducts;
    } catch (e) {
      // Handle errors
      print('Error getting seller sold products: $e');
      return [];
    }
  }



  Future<int> getTotalOrders(String sellerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting total orders: $e');
      return 0;
    }
  }

  Future<double> getTotalSalesAmount(String sellerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      double totalSales = 0;

      for (var doc in querySnapshot.docs) {
        List<Map<String, dynamic>> products =
        List<Map<String, dynamic>>.from(doc['products']);

        for (var productData in products) {
          if (productData.containsKey('salesPrice')) {
            totalSales += (productData['salesPrice'] as num).toDouble();
          }
        }
      }

      return totalSales;
    } catch (e) {
      print('Error getting total sales amount: $e');
      return 0;
    }
  }

  Future<int> getTotalBuyers(String sellerId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      Set<String> uniqueBuyers = Set<String>();

      for (var doc in querySnapshot.docs) {
        List<Map<String, dynamic>> products =
        List<Map<String, dynamic>>.from(doc['products']);

        for (var productData in products) {
          if (productData.containsKey('buyerId')) {
            uniqueBuyers.add(productData['buyerId']);
          }
        }
      }

      return uniqueBuyers.length;
    } catch (e) {
      print('Error getting total buyers: $e');
      return 0;
    }
  }


  Future<Map<String, dynamic>> getProductDetailsById(String productId) async {
    try {
      DocumentSnapshot productSnapshot =
      await FirebaseFirestore.instance.collection('products').doc(productId).get();

      if (productSnapshot.exists) {
        return productSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if the product is not found
      }
    } catch (error) {
      print('Error getting product details: $error');
      throw error;
    }
}

  Future<Map<String, dynamic>?> getOrderDetailsById(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot = await _firestore.collection('orders').doc(orderId).get();
      return orderSnapshot.data() as Map<String, dynamic>?;
    } catch (error) {
      print('Error getting order details: $error');
      return null;
    }
  }

  Future<void> cancelOrder(String orderId, String cancellationReason) async {
    try {
      // Update the order status to 'Cancelled' and store the cancellation reason
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'Cancelled',
        'cancellationReason': cancellationReason,
      });
    } catch (e) {
      // Handle errors
      print('Error cancelling order: $e');
      throw e; // You may want to handle this error in your UI
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerSoldProductsStream(String sellerId) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .snapshots();
    } catch (e) {
      // Handle errors
      print('Error getting seller sold products stream: $e');
      return Stream.empty();
    }
  }



}