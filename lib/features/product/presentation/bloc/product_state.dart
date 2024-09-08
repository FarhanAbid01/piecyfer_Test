part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final DocumentSnapshot? lastDocumentSnapshot;
  final List<Product> products;

  ProductLoaded(this.products, this.lastDocumentSnapshot);
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);
}

// Cart related states
class CartLoading extends ProductState {}

class CartLoaded extends ProductState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);
}

class CartUpdated extends ProductState {
  final List<CartItem> cartItems;
  final int cartCount;

  CartUpdated(this.cartItems)
      : cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);
}
class QuantityUpdated extends ProductState {
  final int productId;
  final int quantity;

  QuantityUpdated(this.productId, this.quantity);
}


