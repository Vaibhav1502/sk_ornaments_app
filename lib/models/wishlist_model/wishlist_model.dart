import 'dart:convert';

// --- Model for the RESPONSE after adding a product to wishlist ---
AddToWishlistResponse addToWishlistResponseFromJson(String str) => AddToWishlistResponse.fromJson(json.decode(str));

class AddToWishlistResponse {
  final String status;
  final String message;

  AddToWishlistResponse({
    required this.status,
    required this.message,
  });

  factory AddToWishlistResponse.fromJson(Map<String, dynamic> json) => AddToWishlistResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
  );
}

// --- Model for FETCHING the entire wishlist ---
WishlistResponse wishlistResponseFromJson(String str) => WishlistResponse.fromJson(json.decode(str));

class WishlistResponse {
  final String status;
  final String message;
  final WishlistData? data;

  WishlistResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) => WishlistResponse(
    status: json["status"] ?? "error",
    message: json["message"] ?? "An unknown error occurred.",
    data: json["data"] != null ? WishlistData.fromJson(json["data"]) : null,
  );
}

class WishlistData {
  final List<WishlistItem> items;

  WishlistData({required this.items});

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
    items: json["items"] == null ? [] : List<WishlistItem>.from(json["items"].map((x) => WishlistItem.fromJson(x))),
  );
}

// This represents a single item in the wishlist
class WishlistItem {
  final int id;
  final String name;
  final String price;
  final String? imagePath;
  final String category;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    this.imagePath,
    required this.category,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    id: json["id"] ?? 0,
    name: json["name"] ?? "Unknown Item",
    price: json["price"]?.toString() ?? "0",
    imagePath: json["image_path"],
    category: json["category"] ?? "Uncategorized",
  );
}