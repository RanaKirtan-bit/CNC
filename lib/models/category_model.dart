import 'package:clickncart/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  Category({this.cartName, this.image});

  Category.fromJson(Map<String, Object?> json)
      : this(
    cartName: json['cartName']! as String,
    image: json['image']! as String,
  );

  final String? cartName;
  final String? image;

  Map<String, Object?> toJson() {
    return {
      'cartName': cartName,
      'image': image,
    };
  }
}
FirebaseService _service = FirebaseService();
final categoryCollection = _service.categories.where('active', isEqualTo: true).withConverter<Category>(
  fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
  toFirestore: (movie, _) => movie.toJson(),
);
