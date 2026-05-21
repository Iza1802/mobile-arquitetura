import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client;
  ProductRemoteDatasource(this.client);

  final String _base = "https://dummyjson.com/products";

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(_base);
    final List data = response.data['products'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get("$_base/$id");
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post("$_base/add", data: product.toJson());
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      "$_base/${product.id}",
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete("$_base/$id");
  }
}
