import 'package:flutter/foundation.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_detail_state.dart';

class ProductDetailViewModel {
  final ProductRepository repository;
  final ValueNotifier<ProductDetailState> state =
      ValueNotifier(const ProductDetailState());

  ProductDetailViewModel(this.repository);

  Future<void> load(int id) async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final product = await repository.getProductById(id);
      state.value =
          state.value.copyWith(isLoading: false, product: product);
    } catch (e) {
      state.value =
          state.value.copyWith(isLoading: false, error: e.toString());
    }
  }
}
