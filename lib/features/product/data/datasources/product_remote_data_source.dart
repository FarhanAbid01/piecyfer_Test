import 'package:piecyfer_test/core/error/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/pagination_model.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

abstract class ProductRemoteDataSource {
  Future<PaginatedProducts> fetchProducts(int limit, DocumentSnapshot? lastProduct);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;
  final ProductLocalDataSource _localDataSource;

  bool isFirstPageCached = false; // Track whether the first page has been cached

  ProductRemoteDataSourceImpl(this._firestore, this._localDataSource);

  @override
  Future<PaginatedProducts> fetchProducts(int limit, DocumentSnapshot? lastProduct) async {
    try {
      Query query = _firestore.collection('products').orderBy('id').limit(limit);

      if (lastProduct != null) {
        query = query.startAfterDocument(lastProduct);
      }

      QuerySnapshot querySnapshot = await query.get();

      // Map the fetched documents to a list of ProductModel objects
      List<ProductModel> products = querySnapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();

      final lastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      // Only cache the first page if it hasn't been cached yet
      if (!isFirstPageCached && lastProduct == null) {
        _localDataSource.uploadLocalProducts(products: products);
        isFirstPageCached = true; // Mark as cached after saving the first page
      }

      return PaginatedProducts(
        products: products,
        lastDocumentSnapshot: lastDocument,
      );
    } catch (e) {
      throw ServerException('Failed to fetch products: $e');
    }
  }
}

