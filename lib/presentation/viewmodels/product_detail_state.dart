import '../../domain/entities/product.dart';

class ProductDetailState {
  final bool isLoading;
  final Product? product;
  final String? error;

  const ProductDetailState({
    this.isLoading = false,
    this.product,
    this.error,
  });

  ProductDetailState copyWith({
    bool? isLoading,
    Product? product,
    String? error,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      error: error,
    );
  }
}
