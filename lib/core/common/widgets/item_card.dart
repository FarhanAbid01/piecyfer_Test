import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../features/product/domain/entities/product.dart';
import '../../constants/constants.dart';



class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.product, required this.press});

  final Product product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(Constants.kDefaultPaddin),
              decoration: BoxDecoration(
                color: Color(int.parse(product.color ?? '0xFFFFFFFF')) ?? Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CachedNetworkImage(
                width: 160,
                // placeholder: (context, url) => ,
                imageUrl: product.imageUrl??'',fit: BoxFit.contain,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.name??'',
              style: const TextStyle(color:Constants.kTextColor),
            ),
          ),
          Text(
            "\$${product.price}",
            style: const TextStyle(fontWeight: FontWeight.bold , color:   Constants.kTextColor),
          )
        ],
      ),
    );
  }
}
