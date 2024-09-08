import 'package:piecyfer_test/core/common/widgets/cart_icon_with_count.dart';
import 'package:piecyfer_test/core/common/widgets/item_card.dart';
import 'package:piecyfer_test/core/common/widgets/user_status.dart';
import 'package:piecyfer_test/features/product/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/constants/constants.dart';
import '../../../../features/product/domain/entities/product.dart';
import '../../../../features/product/presentation/bloc/product_bloc.dart';
class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 1);
  static const _initialLimit = 8;
  final int _pageSize = 8;
  int pageNumber = 1;
  bool _isFirstPageLoaded = false; // Flag to check if the first page is loaded

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      if (!_isFirstPageLoaded) {
        return;
      }
      pageNumber = pageKey;
      context.read<ProductBloc>().add(FetchProducts(limit: _pageSize , pageNumber: pageKey));
    });
    context.read<ProductBloc>().add(FetchProducts(limit: _initialLimit , pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: UserStatusWidget(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Products",
          style: TextStyle(color: Constants.kTextColor, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          CartIconWithCounter(),
          const SizedBox(width: Constants.kDefaultPaddin / 2)
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: Constants.kDefaultPaddin),
            Expanded(
              child: BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductLoaded) {
                    _isFirstPageLoaded = true;

                    final isLastPage = state.products.length < _pageSize;
                    if (isLastPage) {
                      _pagingController.appendLastPage(state.products);
                    } else {
                      final nextPageKey = (_pagingController.nextPageKey ?? 1) + 1;
                      _pagingController.appendPage(state.products, nextPageKey);
                    }
                  } else if (state is ProductFailure) {
                    print('this is message from state${state.message}');
                    _pagingController.error = state.message;
                  }
                },
                child: PagedGridView<int, Product>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Constants.kDefaultPaddin,
                    crossAxisSpacing: Constants.kDefaultPaddin,
                    childAspectRatio: 0.75,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<Product>(
                    itemBuilder: (context, product, index) => ItemCard(
                      product: product,
                      press: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 300),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: ProductDetailsScreen(product: product),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    // Add this to handle error states
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Text(
                        'No products found.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (context) => GestureDetector(
                      onTap: (){
                        context.read<ProductBloc>().add(FetchProducts(limit: _initialLimit, pageNumber: pageNumber));
                      },
                      child: Center(
                        child: Text(
                          _pagingController.error as String? ?? 'Something went wrong. Tap to try again.',
                          style: TextStyle(fontSize: 18, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (context) => GestureDetector(
                      onTap: (){
                        context.read<ProductBloc>().add(FetchProducts(limit: _initialLimit, pageNumber: pageNumber));

                      },
                      child: Center(
                        child: Text(
                          _pagingController.error as String? ?? 'Failed to load more products. Try again later.',
                          style: TextStyle(fontSize: 18, color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                )

              ),
            ),
          ],
        ),
      ),
    );
  }
}

