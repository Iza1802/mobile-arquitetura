import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/product_cache_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bem-vindo ao Product App',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductPage(
                        viewModel: ProductViewModel(
                          ProductRepositoryImpl(
                            ProductRemoteDatasource(Dio()),
                            ProductCacheDatasource(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Ver Produtos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
