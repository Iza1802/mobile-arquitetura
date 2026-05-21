class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      price: json["price"] == null ? 0.0 : (json["price"] as num).toDouble(),
      rating: json["rating"] == null ? 0.0 : (json["rating"] as num).toDouble(),
      stock: json["stock"] is int
          ? json["stock"]
          : int.tryParse(json["stock"]?.toString() ?? "") ?? 0,
      thumbnail: json["thumbnail"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "stock": stock,
    "thumbnail": thumbnail,
  };
}
