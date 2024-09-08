import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../features/product/domain/entities/product.dart';
import '../../constants/constants.dart';


class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.name ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            product.name ?? '',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Constants.kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Price\n"),
                    TextSpan(
                      text: "\$${product.price}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Constants.kDefaultPaddin),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl ?? '',
                    fit: BoxFit.cover,
                    alignment: Alignment.center, // Align the image center
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
