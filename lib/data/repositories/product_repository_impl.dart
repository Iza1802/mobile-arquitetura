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

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models
          .map(
            (m) => Product(
              id: m.id,
              title: m.title,
              price: m.price,
              image: m.image,
              description: m.description,
              category: m.category,
            ),
          )
          .toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached
            .map(
              (m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                description: m.description,
                category: m.category,
              ),
            )
            .toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    final model = ProductModel(
      id: 0,
      title: product.title,
      price: product.price,
      image: product.image,
      description: product.description,
      category: product.category,
    );
    final result = await remote.addProduct(model);
    return Product(
      id: result.id,
      title: result.title,
      price: result.price,
      image: result.image,
      description: result.description,
      category: result.category,
    );
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      description: product.description,
      category: product.category,
    );
    final result = await remote.updateProduct(model);
    return Product(
      id: result.id,
      title: result.title,
      price: result.price,
      image: result.image,
      description: result.description,
      category: result.category,
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    await remote.deleteProduct(id);
  }
}
