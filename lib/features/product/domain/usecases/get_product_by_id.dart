//
//
// import 'package:piecyfer_test/core/error/failures.dart';
// import 'package:piecyfer_test/features/product/domain/entities/product.dart';
// import 'package:piecyfer_test/features/product/domain/repositories/product_repository.dart';
// import 'package:fpdart/fpdart.dart';
//
// import '../../../../core/usecase/usecase.dart';
//
// class GetProductById implements UseCase<Product, Params> {
//   final ProductRepository productRepository;
//
//   GetProductById(this.productRepository);
//
//   @override
//   Future<Either<Failure, Product>> call(Params params) async {
//     return await productRepository.getProductById(params.id);
//   }
// }
//
// /// Params class to pass the product ID
// class Params {
//   final String id;
//
//   Params({required this.id});
// }
