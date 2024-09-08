import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/product/presentation/bloc/product_bloc.dart';
import '../../constants/constants.dart';

class CartIconWithCounter extends StatelessWidget {
  const CartIconWithCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) => current is CartUpdated,
      builder: (context, state) {
        int uniqueProductsCount = 0;

        if (state is CartUpdated) {
          // Get the number of unique products in the cart
          uniqueProductsCount = state.cartItems.length;
        }


        return Stack(
          clipBehavior: Clip.none, // Allow elements to be positioned outside the bounds
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/cart.svg",
                colorFilter: const ColorFilter.mode(Constants.kTextColor, BlendMode.srcIn),
              ),
              onPressed: () {
                // Handle cart icon click, maybe navigate to cart screen
              },
            ),
            if (uniqueProductsCount > 0)
              Positioned(
                right: 0,
                top: -5, // Move the badge up
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red, // Red background for the count
                    borderRadius: BorderRadius.circular(10), // Circular badge
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$uniqueProductsCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
