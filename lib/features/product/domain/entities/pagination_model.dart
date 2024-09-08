import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginatedProducts {
  final List<Product> products;
  final DocumentSnapshot? lastDocumentSnapshot;

  PaginatedProducts({required this.products, required this.lastDocumentSnapshot});
}