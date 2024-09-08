import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends Product {
  // Store Firestore DocumentSnapshot for pagination
  DocumentSnapshot? lastDocumentSnapshot;

  ProductModel({
    required int id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String color,
    this.lastDocumentSnapshot,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    imageUrl: imageUrl,
    color: color,
  );

  // Factory constructor to map Firestore data to ProductModel
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    // Ensure doc exists and has data
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    print("Parsing product data: $data"); // Debugging

    return ProductModel(
      id: (data['id'] as num).toInt(),  // Safely cast id to int
      name: data['name'] ?? 'Unnamed Product',  // Default value if name is missing
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),  // Ensure price is cast to double
      imageUrl: data['imageUrl'] ?? '',
      color: data['color'] ?? '#FFFFFF',  // Default color to white if missing
      lastDocumentSnapshot: doc,  // Store last document for pagination
    );
  }

  // Factory constructor for JSON mapping
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Product',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,  // Safely cast price to double
      imageUrl: json['imageUrl'] ?? '',
      color: json['color'] ?? '#FFFFFF',
    );
  }

  // Convert the ProductModel back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'color': color,
    };
  }
}
