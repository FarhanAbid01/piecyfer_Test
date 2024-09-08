import 'package:piecyfer_test/core/utils/exention.dart';
import 'package:piecyfer_test/features/product/domain/entities/card_item_model.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:piecyfer_test/features/product/domain/usecases/get_all_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/pagination_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts _getAllProducts;
  final ConnectionChecker _connectionChecker; // Inject ConnectionChecker
  DocumentSnapshot? lastProductDocument;
  List<CartItem> _cartItems = [];
  Map<int, int> productQuantities = {}; // Store the temp quantity for each product

  ProductBloc({
    required GetAllProducts getAllProducts,
    required ConnectionChecker connectionChecker, // ConnectionChecker injected
  })  : _getAllProducts = getAllProducts,
        _connectionChecker = connectionChecker,
        super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateProductQuantity>(_onUpdateProductQuantity);
    on<GetCartItems>(_onGetCartItems);
  }

  void _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());


    final isConnected = await _connectionChecker.isConnected;

    final Either<Failure, PaginatedProducts> result = await _getAllProducts(
      Params(limit: event.limit, lastProduct: lastProductDocument),
    );
    print('this is page number ${event.pageNumber}');

    result.fold(
          (failure) => emit(ProductFailure(failure.message)),
          (paginatedProducts) {
       if(!isConnected){
         lastProductDocument = null;
         if(paginatedProducts.products.isEmpty){
           emit(ProductFailure('Please Connect to the Internet'));
          }else {
           if(event.pageNumber!=1){
             emit(ProductFailure('Please Connect to the Internet'));
           }else{
             emit(ProductLoaded(paginatedProducts.products, null));
           }
         }
       }else{
         lastProductDocument = paginatedProducts.lastDocumentSnapshot;
         emit(ProductLoaded(paginatedProducts.products, lastProductDocument!));
       }
      },
    );
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<ProductState> emit) {
    final existingCartItem = _cartItems.firstWhereOrNull(
          (item) => item.product.id == event.product.id,
    );

    if (existingCartItem != null) {
      existingCartItem.quantity += event.quantity;
    } else {
      _cartItems.add(CartItem(product: event.product, quantity: event.quantity));
    }

    emit(CartUpdated(_cartItems)); // Emit updated cart state
  }

  void _onRemoveProductFromCart(RemoveProductFromCart event, Emitter<ProductState> emit) {
    final existingCartItem = _cartItems.firstWhereOrNull(
          (item) => item.product.id == event.product.id,
    );

    if (existingCartItem != null) {
      if (existingCartItem.quantity > 1) {
        existingCartItem.quantity -= 1;
      } else {
        _cartItems.remove(existingCartItem);
      }
    }

    emit(CartUpdated(_cartItems));
  }

  // Update the temporary quantity for a product
  void _onUpdateProductQuantity(UpdateProductQuantity event, Emitter<ProductState> emit) {
    productQuantities[event.product.id ?? 0] = event.quantity;
    emit(QuantityUpdated(event.product.id ?? 0, event.quantity));
  }

  void _onGetCartItems(GetCartItems event, Emitter<ProductState> emit) {
    emit(CartLoaded(_cartItems));
  }


}
