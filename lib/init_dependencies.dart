

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'core/common/cubits/user_status/app_user_cubit.dart';
import 'core/network/connection_checker.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_all_products.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

import 'package:hive/hive.dart';

part 'init_dependencies.main.dart';
