import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:piecyfer_test/features/product/domain/repositories/product_repository.dart';
import 'package:piecyfer_test/features/product/domain/usecases/get_all_products.dart';
import 'package:piecyfer_test/core/error/failures.dart';
import 'package:piecyfer_test/features/product/domain/entities/pagination_model.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetAllProducts usecase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    usecase = GetAllProducts(mockProductRepository);
  });

  final products = [Product(id: 1, name: 'Test Product', description: 'Test', price: 10.0, imageUrl: '', color: '')];
  final paginatedProducts = PaginatedProducts(products: products, lastDocumentSnapshot: null);

  test('should get products from repository', () async {
    when(() => mockProductRepository.fetchProducts(any(), any())).thenAnswer((_) async => Right(paginatedProducts));

    final result = await usecase(Params(limit: 10, lastProduct: null));

    expect(result, Right(paginatedProducts));
    verify(() => mockProductRepository.fetchProducts(10, null)).called(1);
  });

  test('should return failure when repository fails', () async {
    // Mock the failure case
    when(() => mockProductRepository.fetchProducts(any(), any()))
        .thenAnswer((_) async => Left(Failure('Failed to fetch products')));

    // Call the use case
    final result = await usecase(Params(limit: 10, lastProduct: null));

    // Assert that the result is a Left(Failure)
    expect(result.isLeft(), true);

    // Extract the Failure and compare the message
    result.fold(
          (failure) => expect(failure.message, 'Failed to fetch products'),
          (success) => fail('Should not return a successful result'),
    );

    // Verify that the repository method was called once with the correct arguments
    verify(() => mockProductRepository.fetchProducts(10, null)).called(1);
  });

}
