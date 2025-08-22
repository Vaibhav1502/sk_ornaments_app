import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/wishlist_model/wishlist_model.dart';
import '../../services/wishlist_service/wishlist_service.dart';
import '../product_detail_screen/product_detail_screen.dart'; // To navigate to details

const Color kBackgroundColor = Color(0xFFF7F5F2);
const Color kPrimaryTextColor = Color(0xFF8B6B3A);
const Color kSecondaryTextColor = Color(0xFF7D7D7D);
const Color kAccentColor = Color(0xFFC09E6F);
const Color kSubtleBackgroundColor = Color(0xFFFFFFFF);

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<WishlistItem>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = WishlistService.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: GoogleFonts.playfairDisplay(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        surfaceTintColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: kPrimaryTextColor),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WishlistItem>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitFoldingCube(color: kAccentColor));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: kSecondaryTextColor),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your Wishlist is Empty",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: kSecondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the heart on any product to save it here.",
                    style: TextStyle(color: kSecondaryTextColor),
                  ),
                ],
              ),
            );
          }

          final wishlistItems = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: wishlistItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              return _WishlistItemCard(item: item)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: (100 * index).ms)
                  .slideX(begin: -0.2);
            },
          );
        },
      ),
    );
  }
}

class _WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  const _WishlistItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item.imagePath != null
            ? "https://staging.skornaments.com/${item.imagePath}"
            : "https://via.placeholder.com/150x150.png?text=No+Image";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: item.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: kPrimaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category.capitalize1(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: kSecondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${item.price}",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: kAccentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Implement Remove from Wishlist logic
              },
              icon: const Icon(
                Icons.close,
                color: kSecondaryTextColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize1() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
