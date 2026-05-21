import 'package:flutter/material.dart';

import '../../domain/repositories/product_repository.dart';
import '../viewmodels/product_detail_state.dart';
import '../viewmodels/product_detail_viewmodel.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final ProductRepository repository;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.repository,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProductDetailViewModel(widget.repository);
    viewModel.load(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: ValueListenableBuilder<ProductDetailState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          final product = state.product;
          if (product == null) {
            return const Center(child: Text('Produto não encontrado'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.thumbnail,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const SizedBox(
                      height: 250,
                      child: Center(child: Icon(Icons.broken_image, size: 64)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Categoria: ${product.category}'),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(product.rating.toStringAsFixed(2)),
                    const SizedBox(width: 16),
                    Text('Estoque: ${product.stock}'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(product.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
