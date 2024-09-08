// Domain/entities/cart_item.dart

import 'package:piecyfer_test/features/product/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
