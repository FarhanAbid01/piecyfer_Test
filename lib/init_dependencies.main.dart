part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  _initProductFeature();
}

Future<void> _initCore() async {
  await Firebase.initializeApp();

  // Register InternetConnection
  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(InternetConnection()),
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;


  serviceLocator.registerLazySingleton(
        () => Hive.box(name: 'products'),
  );

  // Register Firebase Firestore instance
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

}

void _initProductFeature() {
  // Datasource
  serviceLocator
    ..registerFactory<ProductRemoteDataSource>(
          () => ProductRemoteDataSourceImpl(
        serviceLocator(),
            serviceLocator()// Inject Firestore instance
      ),
    )
    ..registerFactory<ProductLocalDataSource>(
          () => ProductLocalDataSourceImpl(serviceLocator()), // Inject Hive Box instance
    )

  // Repository
    ..registerFactory<ProductRepository>(
          () => ProductRepositoryImpl(
            localDataSource: serviceLocator(),
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )

  // Use cases
    ..registerFactory(
          () => GetAllProducts(
        serviceLocator(),
      ),
    )
  // ..registerFactory(
  //       () => GetProductById(
  //     serviceLocator(),
  //   ),
  // )

  // Bloc
    ..registerLazySingleton(
          () => ProductBloc(
        connectionChecker: serviceLocator(),
        getAllProducts: serviceLocator(),
        // getProductById: serviceLocator(),
      ),
    );

  serviceLocator.registerLazySingleton(
        () => UserStatusCubit(serviceLocator<ConnectionChecker>()), // Injecting ConnectionChecker (not ConnectionCheckerImpl)
  );


}
