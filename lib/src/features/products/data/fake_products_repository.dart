import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

// Create a provider instance for the repository - Similar to creating a Singleton
// Note that this is a provider of type `FakeProductsRepository`
// and we can create a provider of any type in dart.
final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider = StreamProvider<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProduct(id);
});

/*
   How to Create Providers
    1. Declare as global variable: 
       - can be accessed from anywhere in the app
       - e.g. productRepositoryProvider
    2. Specify the provider as a Provider<T>
       - T is the type of the provider
       - e.g. Provider<FakeProductsRepository>
    3. Implement the body of the provider
       - e.g. return FakeProductsRepository.instance
*/
