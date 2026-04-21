import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 250,
                fit: BoxFit.contain,
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
            Text('R\$ ${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
