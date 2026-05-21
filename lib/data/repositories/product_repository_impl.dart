import '../datasources/product_remote_datasource.dart';
import '../datasources/product_cache_datasource.dart';
import '../models/product_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/errors/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  Product _toEntity(ProductModel m) => Product(
    id: m.id,
    title: m.title,
    description: m.description,
    category: m.category,
    price: m.price,
    rating: m.rating,
    stock: m.stock,
    thumbnail: m.thumbnail,
  );

  ProductModel _toModel(Product p) => ProductModel(
    id: p.id,
    title: p.title,
    description: p.description,
    category: p.category,
    price: p.price,
    rating: p.rating,
    stock: p.stock,
    thumbnail: p.thumbnail,
  );

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models.map(_toEntity).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map(_toEntity).toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remote.getProductById(id);
      return _toEntity(model);
    } catch (e) {
      throw Failure("Não foi possível carregar o produto");
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    final result = await remote.addProduct(_toModel(product));
    return _toEntity(result);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final result = await remote.updateProduct(_toModel(product));
    return _toEntity(result);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remote.deleteProduct(id);
  }
}
