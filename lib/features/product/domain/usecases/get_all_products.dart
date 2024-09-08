

import 'package:piecyfer_test/core/error/failures.dart';
import 'package:piecyfer_test/features/product/domain/entities/pagination_model.dart';
import 'package:piecyfer_test/features/product/domain/repositories/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
class GetAllProducts implements UseCase<PaginatedProducts, Params> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<Failure, PaginatedProducts>> call(Params params) async {
    return await repository.fetchProducts(params.limit, params.lastProduct);
  }
}

class Params {
  final int limit;
  final DocumentSnapshot? lastProduct;

  Params({required this.limit, this.lastProduct});
}
