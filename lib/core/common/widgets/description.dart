import 'package:piecyfer_test/core/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../../features/product/domain/entities/product.dart';



class Description extends StatelessWidget {
  const Description({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPaddin),
      child: Text(
        product.description??'',
        style: const TextStyle(height: 1.5 , color: Constants.kTextColor),
      ),
    );
  }
}
