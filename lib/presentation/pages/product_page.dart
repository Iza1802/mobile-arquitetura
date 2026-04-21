import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product state.dart';
import '../../domain/entities/product.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;
  const ProductPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.error != null) {
            return Center(
              child: Text(state.error!),
            );
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.title),
                subtitle: Text("\$${product.price}"),
                trailing: IconButton(
                  icon: Icon(
                    product.favorite ? Icons.star : Icons.star_border,
                    color: product.favorite ? Colors.amber : null,
                  ),
                  onPressed: () => viewModel.toggleFavorite(product.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.loadProducts,
        child: const Icon(Icons.download),
      ),
    );
  }
}
