import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model/product_model.dart';
import '../../services/product_service/product_service.dart';
import '../product_detail_screen/product_detail_screen.dart';

// --- Using a consistent, professional theme ---
const Color kBackgroundColor = Color(0xFFF7F5F2);
const Color kPrimaryTextColor = Color(0xFF333333);
const Color kSecondaryTextColor = Color(0xFF7D7D7D);
const Color kAccentColor = Color(0xFFC09E6F);
const Color kBorderColor = Color(0xFFEAEAEA);

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Our Collection",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B6B3A),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: kPrimaryTextColor),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitFoldingCube(color: kAccentColor,));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(snapshot.error?.toString() ?? "No products found."));
          }

          final products = snapshot.data!;
          return MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              // Use a different aspect ratio for items to create the staggered effect
              final aspectRatio = index.isEven ? 0.75 : 0.9;
              return _ProductCard(
                product: product,
                aspectRatio: aspectRatio,
              ).animate().fadeIn(duration: 600.ms, delay: (100 * (index % 10)).ms).slideY(begin: 0.3, curve: Curves.easeOut);
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final double aspectRatio;

  const _ProductCard({required this.product, required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty
        ? "https://staging.skornaments.com/${product.images.first.imagePath}"
        : "";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorderColor, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Hero(
                  tag: "product_${product.id}", // Ensure Hero tag is here
                  child: Container(
                    color: kBorderColor, // A subtle background color for images
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      // A more subtle loading indicator
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SpinKitFoldingCube(
                            // strokeWidth: 2,
                            // value: loadingProgress.expectedTotalBytes != null
                            //     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            //     : null,
                            color: kAccentColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image_outlined, color: kSecondaryTextColor),
                    )
                        : const Icon(Icons.image_not_supported_outlined, color: kSecondaryTextColor),
                  ),
                ),
              ),
              // Text content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${product.price}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}