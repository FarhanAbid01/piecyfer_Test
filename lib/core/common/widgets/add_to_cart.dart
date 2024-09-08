import 'package:piecyfer_test/core/constants/constants.dart';
import 'package:piecyfer_test/core/utils/colour_extention.dart';
import 'package:piecyfer_test/features/product/domain/entities/product.dart';
import 'package:piecyfer_test/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';



class AddToCart extends StatelessWidget {
  const AddToCart({super.key, required this.product , required this.onPressed});
  final VoidCallback onPressed;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                onPressed();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                backgroundColor:  Color(int.parse(product.color ?? '0xFFFFFFFF')) ?? Colors.white,
              ),
              child: Text(
                "Add to Cart".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
