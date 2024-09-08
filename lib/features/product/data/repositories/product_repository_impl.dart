

import 'package:piecyfer_test/core/error/exceptions.dart';
import 'package:piecyfer_test/core/error/failures.dart';
import 'package:piecyfer_test/core/network/connection_checker.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/pagination_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, PaginatedProducts>> fetchProducts(int limit, DocumentSnapshot? lastProduct) async {
    try {
      // Check internet connection before attempting to fetch remote data
      if (!await connectionChecker.isConnected) {
        final localProducts = localDataSource.loadProducts();
        return right(PaginatedProducts(
          products: localProducts,
          lastDocumentSnapshot:null,
        ));
      }

      final productModels = await remoteDataSource.fetchProducts(limit, lastProduct);

      // Convert ProductModel to Product (Domain Layer)
      final products = productModels.products.map((model) => Product(
        id: model.id,
        name: model.name,
        description: model.description,
        price: model.price,
        imageUrl: model.imageUrl,
        color: model.color,
      )).toList();

      return Right(PaginatedProducts(
        products: products,
        lastDocumentSnapshot:productModels.lastDocumentSnapshot,
      ));

      // Cache the products locally
      // localDataSource.cacheProducts(remoteProducts);

    } on ServerException catch (e){
      return left(Failure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, Product>> getProductById(String id) async {
  //   try {
  //     // Check internet connection before attempting to fetch remote data
  //     if (!await connectionChecker.isConnected) {
  //       // final localProduct = localDataSource.getCachedProductById(id);
  //       // return right(localProduct);
  //     }
  //
  //     final remoteProduct = await remoteDataSource.getProductById(id);
  //
  //     // Cache the product locally
  //     // localDataSource.cacheProduct(remoteProduct);
  //
  //     return right(remoteProduct);
  //   } on ServerException catch(e){
  //     return left(Failure(e.toString()));
  //   }
  // }
}
