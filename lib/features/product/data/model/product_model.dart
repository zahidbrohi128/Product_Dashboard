import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String brand,
    required String category,
    required String thumbnail,
    required List<String> images,
  }) : super(
    id: id,
    title: title,
    description: description,
    price: price,
    discountPercentage: discountPercentage,
    rating: rating,
    stock: stock,
    brand: brand,
    category: category,
    thumbnail: thumbnail,
    images: images,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? 'N/A',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  // Create a new factory to easily convert from an Entity to a Model
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      rating: entity.rating,
      stock: entity.stock,
      brand: entity.brand,
      category: entity.category,
      thumbnail: entity.thumbnail,
      images: entity.images,
    );
  }

  // FIX: Make the toJson method more complete for API updates
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'brand': brand,
      'rating': rating,
    };
  }
}