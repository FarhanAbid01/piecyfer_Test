import 'package:piecyfer_test/core/common/widgets/description.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/add_to_cart.dart';
import '../../../../core/common/widgets/cart_icon_with_count.dart';
import '../../../../core/common/widgets/product_with_image.dart';
import '../../../../core/constants/constants.dart';
import '../bloc/product_bloc.dart';



class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    int productQuantity =  context.read<ProductBloc>().productQuantities[product.id] ?? 1;


    final Size size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: Color(int.parse(product.color ?? '0xFFFFFFFF')),
      appBar: AppBar(
        backgroundColor: Color(int.parse(product.color ?? '0xFFFFFFFF')),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          CartIconWithCounter(),
          const SizedBox(width: Constants.kDefaultPaddin / 2),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: Constants.kDefaultPaddin,
                      right: Constants.kDefaultPaddin,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: Constants.kDefaultPaddin / 2),
                        Description(product: product),
                        const SizedBox(height: Constants.kDefaultPaddin / 2),
                        BlocBuilder<ProductBloc, ProductState>(
                          buildWhen: (previous, current) => current is QuantityUpdated,
                          builder: (context, state) {
                            print('state is $state');
                            if (state is QuantityUpdated && state.productId == product.id) {
                              productQuantity = state.quantity;
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
                                      if (productQuantity > 1) {
                                        context.read<ProductBloc>().add(UpdateProductQuantity(product: product, quantity: productQuantity - 1));
                                      }
                                    },
                                    child: const Icon(Icons.remove , color: Colors.black,),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPaddin / 2),
                                  child: Text(
                                    productQuantity.toString().padLeft(2, "0"),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.black,
                                    ),
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
                                      context.read<ProductBloc>().add(UpdateProductQuantity(product: product, quantity: productQuantity + 1));
                                    },
                                    child: const Icon(Icons.add , color: Colors.black,),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: Constants.kDefaultPaddin / 2),
                        AddToCart(
                          product: product,
                          onPressed: () {
                            context.read<ProductBloc>().add(AddProductToCart(product: product, quantity: productQuantity));
                          },
                        ),
                      ],
                    ),
                  ),
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: ModalRoute.of(context)!.animation!,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: ProductTitleWithImage(product: product),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


