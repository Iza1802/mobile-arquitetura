import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_cache_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProductPage(
        viewModel: ProductViewModel(
          ProductRepositoryImpl(
            ProductRemoteDatasource(Dio()),
            ProductCacheDatasource(),
          ),
        ),
      ),
    );
  }
}
