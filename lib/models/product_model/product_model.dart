class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String labourCharges;
  final String gstPercentage;
  final Category category;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.labourCharges,
    required this.gstPercentage,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      labourCharges: json['labour_charges'] ?? '0',
      gstPercentage: json['gst_percentage'] ?? '0',
      category: Category.fromJson(json['category']),
      images: (json['images'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ProductImage {
  final int id;
  final String imagePath;

  ProductImage({
    required this.id,
    required this.imagePath,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imagePath: json['image_path'] ?? '',
    );
  }
}
