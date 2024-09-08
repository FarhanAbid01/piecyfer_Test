import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/product/domain/entities/card_item_model.dart';
import '../../../features/product/presentation/bloc/product_bloc.dart';
import '../../constants/constants.dart';

class CartCounter extends StatelessWidget {
  final Product product;

  const CartCounter({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {

        int numOfItems = 1; // Default count

        if (state is CartUpdated) {
          final cartItem = state.cartItems.firstWhere(
                (item) => item.product.id == product.id,
            orElse: () => CartItem(product: product, quantity: 1),
          );
          numOfItems = cartItem.quantity;
        }

        return Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  if (numOfItems > 1) {
                    context.read<ProductBloc>().add(RemoveProductFromCart(product: product));
                  }
                },
                child: const Icon(Icons.remove),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPaddin / 2),
              child: Text(
                // Display item count, format as "01", "02", etc.
                numOfItems.toString().padLeft(2, "0"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              width: 40,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {

                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
