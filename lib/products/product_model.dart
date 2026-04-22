import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  double price;
  int stock;
  String? imagePath;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imagePath
  });

  // Convert Firestore Document to Dart Object (From Firestore to object)
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id, // We use the document ID as the product ID
      name: data['name'] ?? 'Unknown',
      price: (data['price'] ?? 0.0).toDouble(),
      stock: data['stock'] ?? 0,
      imagePath: data['image_path']
    );
  }

  // Convert Dart Object to Map (to save in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'updated_at': FieldValue.serverTimestamp(), // Always track when data changes!
      'image_path': imagePath
    };
  }
}