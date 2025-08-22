import 'dart:convert';

// Helper function to safely parse a dynamic value (String or num) to a double.
double _parseDynamicToDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class ProductDetail {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? imagePath;
  final Category? category;
  final List<ProductImage> images;
  final List<PricingDetail> pricingDetails;
  final PricingBreakup? pricingBreakup;

  ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
    this.category,
    required this.images,
    required this.pricingDetails,
    this.pricingBreakup,
  });

  // ========== MAJOR FIX: CORRECTLY PARSING THE NESTED API RESPONSE ==========
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    // The API nests most product data inside a 'product' object.
    final Map<String, dynamic> productJson = json['product'] ?? {};

    return ProductDetail(
      // Read product-specific fields from the nested 'productJson'
      id: productJson["id"] ?? 0,
      name: productJson["name"] ?? "",
      description: productJson["description"] ?? "",
      price: productJson["price"]?.toString() ?? "0",
      imagePath: productJson["image_path"],
      category: productJson["category"] != null
          ? Category.fromJson(productJson["category"])
          : null,
      images: (productJson["images"] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      pricingDetails: (productJson["pricing_details"] as List? ?? [])
          .map((e) => PricingDetail.fromJson(e))
          .toList(),

      // 'pricing_breakup' is at the top level, so we read it from the parent 'json'
      pricingBreakup: json["pricing_breakup"] != null
          ? PricingBreakup.fromJson(json["pricing_breakup"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "image_path": imagePath,
      "category": category?.toJson(),
      "images": images.map((e) => e.toJson()).toList(),
      "pricing_details": pricingDetails.map((e) => e.toJson()).toList(),
      "pricing_breakup": pricingBreakup?.toJson(),
    };
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({ required this.id, required this.name, required this.image });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}

class ProductImage {
  final int id;
  final String imagePath;

  ProductImage({required this.id, required this.imagePath});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json["id"] ?? 0,
      imagePath: json["image_path"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "image_path": imagePath};
}

class PricingDetail {
  final String component;
  final String weight;
  final String rate;
  final String totalValue;

  PricingDetail({
    required this.component,
    required this.weight,
    required this.rate,
    required this.totalValue,
  });

  factory PricingDetail.fromJson(Map<String, dynamic> json) {
    return PricingDetail(
      component: json["component"] ?? "",
      weight: json["weight"]?.toString() ?? "0",
      rate: json["rate"]?.toString() ?? "0",
      totalValue: json["total_value"]?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {
    "component": component, "weight": weight, "rate": rate, "total_value": totalValue,
  };
}

class PricingBreakup {
  final List<PricingDetail> components;
  final double subtotal;
  final double labourCharges;
  final double gstPercentage;
  final double gstAmount;
  final double grandTotal;

  PricingBreakup({
    required this.components,
    required this.subtotal,
    required this.labourCharges,
    required this.gstPercentage,
    required this.gstAmount,
    required this.grandTotal,
  });

  factory PricingBreakup.fromJson(Map<String, dynamic> json) {
    return PricingBreakup(
      components: (json["components"] as List? ?? [])
          .map((e) => PricingDetail.fromJson(e))
          .toList(),
      // Use the robust helper function for all numeric fields
      subtotal: _parseDynamicToDouble(json["subtotal"]),
      labourCharges: _parseDynamicToDouble(json["labour_charges"]),
      gstPercentage: _parseDynamicToDouble(json["gst_percentage"]),
      gstAmount: _parseDynamicToDouble(json["gst_amount"]),
      grandTotal: _parseDynamicToDouble(json["grand_total"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "components": components.map((e) => e.toJson()).toList(),
    "subtotal": subtotal, "labour_charges": labourCharges,
    "gst_percentage": gstPercentage, "gst_amount": gstAmount,
    "grand_total": grandTotal,
  };
}