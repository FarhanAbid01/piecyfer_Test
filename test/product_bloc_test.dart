import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piecyfer_test/features/product/presentation/bloc/product_bloc.dart';
import 'package:piecyfer_test/features/product/domain/usecases/get_all_products.dart';
import 'package:piecyfer_test/core/network/connection_checker.dart';
import 'package:piecyfer_test/features/product/domain/entities/pagination_model.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';
import 'package:piecyfer_test/core/error/failures.dart';

// Create the FakeParams class for testing
class FakeParams extends Fake implements Params {}

// Mocks for testing
class MockGetAllProducts extends Mock implements GetAllProducts {}
class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  late ProductBloc productBloc;
  late MockGetAllProducts mockGetAllProducts;
  late MockConnectionChecker mockConnectionChecker;

  // Register FakeParams before all tests
  setUpAll(() {
    registerFallbackValue(FakeParams());
  });

  setUp(() {
    mockGetAllProducts = MockGetAllProducts();
    mockConnectionChecker = MockConnectionChecker();
    productBloc = ProductBloc(
      getAllProducts: mockGetAllProducts,
      connectionChecker: mockConnectionChecker,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  final products = [Product(id: 1, name: 'Test Product', description: 'Test', price: 10.0, imageUrl: '', color: '')];
  final paginatedProducts = PaginatedProducts(products: products, lastDocumentSnapshot: null);

  // Test case 1: Successful product fetching with internet
  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when products are fetched successfully with internet',
    build: () {
      when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => mockGetAllProducts(any())).thenAnswer((_) async => Right(paginatedProducts));
      return productBloc;
    },
    act: (bloc) => bloc.add(FetchProducts(limit: 10, pageNumber: 1)),
    expect: () => [
      ProductLoading(),
      ProductLoaded(products, null),  // Make sure this matches what is emitted from your bloc
    ],
  );


  // Test case 2: Failure due to no internet connection
  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductFailure] when there is no internet and products cannot be fetched',
    build: () {
      when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => false);
      when(() => mockGetAllProducts(any())).thenAnswer((_) async => Left(Failure('No internet connection')));
      return productBloc;
    },
    act: (bloc) => bloc.add(FetchProducts(limit: 10, pageNumber: 1)),
    expect: () => [
      ProductLoading(),
      ProductFailure('No internet connection'),
    ],
  );
}
