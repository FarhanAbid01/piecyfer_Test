part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int limit;
  final int pageNumber;

  FetchProducts({required this.limit , required this.pageNumber});
}

class FetchProductById extends ProductEvent {
  final String productId;

  FetchProductById({required this.productId});
}

class AddProductToCart extends ProductEvent {
  final Product product;
  final int quantity;

  AddProductToCart({required this.product, required this.quantity});
}

class RemoveProductFromCart extends ProductEvent {
  final Product product;

  RemoveProductFromCart({required this.product});
}

class UpdateProductQuantity extends ProductEvent {
  final Product product;
  final int quantity;

  UpdateProductQuantity({required this.product, required this.quantity});
}

class GetCartItems extends ProductEvent {}
