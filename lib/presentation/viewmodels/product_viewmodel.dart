import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product state.dart';

class ProductViewModel {
  final ProductRepository repository;
  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());
  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final created = await repository.addProduct(product);
      final newProduct = Product(
        id: created.id != 0
            ? created.id
            : DateTime.now().millisecondsSinceEpoch,
        title: product.title,
        price: product.price,
        image: product.image,
        description: product.description,
        category: product.category,
      );
      final updated = [...state.value.products, newProduct];
      state.value = state.value.copyWith(products: updated);
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await repository.updateProduct(product);
      final updated = state.value.products
          .map((p) => p.id == product.id ? product : p)
          .toList();
      state.value = state.value.copyWith(products: updated);
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      final updated = state.value.products.where((p) => p.id != id).toList();
      state.value = state.value.copyWith(products: updated);
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
    }
  }
}
