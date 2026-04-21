class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"].toString()) ?? 0,
      title: json["title"] ?? "",
      price: (json["price"] as num).toDouble(),
      image: json["image"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "price": price,
    "image": image,
    "description": description,
    "category": category,
  };
}
