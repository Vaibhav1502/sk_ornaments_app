import 'dart:convert';

// Helper function to decode the JSON string
AddToCartResponse addToCartResponseFromJson(String str) => AddToCartResponse.fromJson(json.decode(str));

class AddToCartResponse {
  final String status;
  final String message;
  final CartData? data;

  AddToCartResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) => AddToCartResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
    data: json["data"] != null ? CartData.fromJson(json["data"]) : null,
  );
}

class CartData {
  final int cartCount;
  final num cartTotal; // Use num to handle both int and double from JSON
  final AddedItem addedItem;

  CartData({
    required this.cartCount,
    required this.cartTotal,
    required this.addedItem,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    cartCount: json["cart_count"] ?? 0,
    cartTotal: json["cart_total"] ?? 0,
    addedItem: AddedItem.fromJson(json["added_item"] ?? {}),
  );
}

class AddedItem {
  final int id;
  final String name;
  final String price;
  final String? imagePath;
  final int quantity;
  final String category;

  AddedItem({
    required this.id,
    required this.name,
    required this.price,
    this.imagePath,
    required this.quantity,
    required this.category,
  });

  factory AddedItem.fromJson(Map<String, dynamic> json) => AddedItem(
    id: json["id"] ?? 0,
    name: json["name"] ?? "Unknown Item",
    price: json["price"]?.toString() ?? "0",
    imagePath: json["image_path"],
    quantity: json["quantity"] ?? 0,
    category: json["category"] ?? "Uncategorized",
  );
}