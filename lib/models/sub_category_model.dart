import 'package:clickncart/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory {

  SubCategory({this.mainCategory, this.subCartName, this.image});
  SubCategory.fromJson(Map<String, Object?> json)
      : this(
    mainCategory: json['mainCategory']! as String,
    subCartName: json['subCartName']! as String,
    image: json['image']! as String,
  );

  final String? mainCategory;
  final String? subCartName;
  final String? image;

  Map<String, Object?> toJson() {
    return {
      'mainCategory': mainCategory,
      'subCartName': subCartName,
      'image': image,
    };
  }


}
FirebaseService _service = FirebaseService();
subCategoryCollection({selectedSubCart}){
  return _service.subCategories.where('active', isEqualTo: true).where('mainCategory', isEqualTo: selectedSubCart).withConverter<SubCategory>(
      fromFirestore: (snapshot, _) => SubCategory.fromJson(snapshot.data()!),
  toFirestore: (movie, _) => movie.toJson(),
  );
}

