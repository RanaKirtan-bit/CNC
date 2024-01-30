import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection(
      'categorise');
  CollectionReference mainCategorise = FirebaseFirestore.instance.collection(
            'mainCategorise');
        CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategorise');
        CollectionReference sellers = FirebaseFirestore.instance.collection('sellers');
/*
       Future<List<String>> getMainCategories() async {
                QuerySnapshot querySnapshot = await mainCart.get();
                List<String> categories = querySnapshot.docs.map((
                    doc) => doc['mainCategory'] as String).toList();
                return categories;
        }

        Future<List<String>> getSubCategories(String mainCategory) async {
                QuerySnapshot querySnapshot = await subCart
                    .where('mainCategory', isEqualTo: mainCategory)
                    .get();
                List<String> subCategories =
                querySnapshot.docs.map((doc) => doc['subCartName'] as String).toList();
                return subCategories;
        }
*/
  Future<DocumentSnapshot> getSellerById(String sellerId) async {
    try {
      return await _firestore.collection('sellers').doc(sellerId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching seller data by ID: $error");
      throw error;
    }
  }

}


