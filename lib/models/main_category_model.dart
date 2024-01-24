import 'package:clickncart/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainCategory {
  MainCategory({this.category, this.mainCategory});

  MainCategory.fromJson(Map<String, Object?> json)
      : this(
    category: json['category']! as String,
    mainCategory: json['mainCategory']! as String,
  );

  final String? category;
  final String? mainCategory;

  Map<String, Object?> toJson() {
    return {
      'category': category,
      'mainCategory': mainCategory,
    };
  }


}
FirebaseService _service = FirebaseService();
 mainCategoryCollection (selectedCart){
   return _service.mainCategorise.where('approved', isEqualTo: true).where('category', isEqualTo: selectedCart).withConverter<MainCategory>(
fromFirestore: (snapshot, _) => MainCategory.fromJson(snapshot.data()!),
toFirestore: (movie, _) => movie.toJson(),);
 }
