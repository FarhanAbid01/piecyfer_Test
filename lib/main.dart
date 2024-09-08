

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/common/cubits/user_status/app_user_cubit.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/pages/product_home.dart';
import 'init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserStatusCubit>(
        create: (_) => serviceLocator<UserStatusCubit>(),
      ),
      BlocProvider(

        create: (_) => serviceLocator<ProductBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      home:  ProductScreen(),  // Directly load the Product Home Page
    );
  }
}
