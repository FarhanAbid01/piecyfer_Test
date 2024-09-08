import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piecyfer_test/features/product/data/datasources/product_local_data_source.dart';
import 'package:piecyfer_test/features/product/data/datasources/product_remote_data_source.dart';
import 'package:piecyfer_test/features/product/data/models/product_model.dart';
import 'package:piecyfer_test/features/product/data/repositories/product_repository_impl.dart';
import 'package:piecyfer_test/core/network/connection_checker.dart';
import 'package:piecyfer_test/core/error/failures.dart';
import 'package:piecyfer_test/core/error/exceptions.dart';
import 'package:piecyfer_test/features/product/domain/entities/pagination_model.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockConnectionChecker mockConnectionChecker;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockConnectionChecker = MockConnectionChecker();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectionChecker: mockConnectionChecker,
    );
  });

  group('fetchProducts', () {
    final products = [Product(id: 1, name: 'Test Product', description: 'Test', price: 10.0, imageUrl: '', color: '')];
    final paginatedProducts = PaginatedProducts(products: products, lastDocumentSnapshot: null);

    test('should fetch products from remote when internet is available', () async {
      when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchProducts(any(), any())).thenAnswer((_) async => paginatedProducts);

      final result = await repository.fetchProducts(10, null);

      expect(result.isRight(), true);

      final fetchedProducts = result.getOrElse((failure) => PaginatedProducts(products: [], lastDocumentSnapshot: null)).products;
      expect(fetchedProducts.first.id, products.first.id);
      expect(fetchedProducts.first.name, products.first.name);
    });

    test('should fetch products from local when no internet connection', () async {
      when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => false);

      final productModels = [ProductModel(id: 1, name: 'Test Product', description: 'Test', price: 10.0, imageUrl: '', color: '')];
      when(() => mockLocalDataSource.loadProducts()).thenReturn(productModels);

      final expectedProducts = productModels.map((model) => Product(
        id: model.id,
        name: model.name,
        description: model.description,
        price: model.price,
        imageUrl: model.imageUrl,
        color: model.color,
      )).toList();

      final result = await repository.fetchProducts(10, null);

      expect(result.isRight(), true);

      final fetchedProducts = result.getOrElse((failure) => PaginatedProducts(products: [], lastDocumentSnapshot: null)).products;
      expect(fetchedProducts.first.id, expectedProducts.first.id);
      expect(fetchedProducts.first.name, expectedProducts.first.name);
    });

    test('should return server failure when remote fetching fails', () async {
      when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchProducts(any(), any())).thenThrow(const ServerException('Failed to fetch products'));

      final result = await repository.fetchProducts(10, null);

      expect(result.isLeft(), true);
      expect(result.swap().getOrElse((paginatedProducts) => Failure('')).message, 'Failed to fetch products');
    });

  });
}
