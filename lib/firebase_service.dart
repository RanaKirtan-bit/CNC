import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
        CollectionReference mainCart = FirebaseFirestore.instance.collection(
            'mainCategorise');
        CollectionReference subCart = FirebaseFirestore.instance.collection('subCategorise');

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
}

