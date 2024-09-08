import 'package:piecyfer_test/core/error/failures.dart';
import 'package:piecyfer_test/features/product/domain/entities/pagination_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product.dart';


abstract class ProductRepository {

  Future<Either<Failure, PaginatedProducts>> fetchProducts(int limit, DocumentSnapshot? lastProduct);



}
