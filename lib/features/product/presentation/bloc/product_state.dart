part of 'product_bloc.dart';



abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final DocumentSnapshot? lastDocumentSnapshot;
  final List<Product> products;

  ProductLoaded(this.products, this.lastDocumentSnapshot);

  @override
  List<Object?> get props => [products, lastDocumentSnapshot];
}

class ProductFailure extends ProductState {
  final String message;

  ProductFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Cart related states
class CartLoading extends ProductState {}

class CartLoaded extends ProductState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartUpdated extends ProductState {
  final List<CartItem> cartItems;
  final int cartCount;

  CartUpdated(this.cartItems)
      : cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [cartItems, cartCount];
}

class QuantityUpdated extends ProductState {
  final int productId;
  final int quantity;

  QuantityUpdated(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}


