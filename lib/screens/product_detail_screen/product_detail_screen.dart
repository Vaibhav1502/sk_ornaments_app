import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/cart_service/cart_service.dart';
import '../../models/product_detail_model/product_detail_model.dart';
import '../../services/product_detail_service/product_detail_service.dart';

// --- Theme constants ---
const Color kBackgroundColor = Color(0xFF25231D);
const Color kAccentColor = Color(0xFFD3B88C);
const Color kLightTextColor = Color(0xFFEAEAEA);

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ProductDetail> _productDetailFuture;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollPosition = ValueNotifier(0.0);

  // --- NEW: State for tracking the cart operation ---
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _productDetailFuture = ProductDetailService.fetchProductDetail(widget.productId);
    _scrollController.addListener(() {
      _scrollPosition.value = _scrollController.position.pixels;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollPosition.dispose();
    super.dispose();
  }

  // --- NEW: Method to handle the add to cart logic ---
  Future<void> _handleAddToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final response = await CartService.addToCart(
        productId: widget.productId,
        quantity: 1, // Defaulting to 1 for this example
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", ""), style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FutureBuilder<ProductDetail>(
        future: _productDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kAccentColor));
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.error?.toString() ?? "Product not found.",
                style: const TextStyle(color: kLightTextColor),
              ),
            );
          }

          final product = snapshot.data!;
          final mainImageUrl = product.images.isNotEmpty
              ? "https://staging.skornaments.com/${product.images.first.imagePath}"
              : "https://via.placeholder.com/600x600.png?text=No+Image";

          return Stack(
            children: [
              _buildParallaxBackground(mainImageUrl, product),
              _buildContentSheet(product),
              _buildCustomBackButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParallaxBackground(String imageUrl, ProductDetail product) {
    // This widget remains unchanged
    return ValueListenableBuilder<double>(
      valueListenable: _scrollPosition,
      builder: (context, value, child) {
        final parallaxOffset = -value * 0.3;
        return Positioned(
          top: parallaxOffset,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: "product_${widget.productId}",
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, kBackgroundColor.withOpacity(0.8), kBackgroundColor],
                    stops: const [0.0, 0.8, 1.0],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSheet(ProductDetail product) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.6),
            Text(
              product.name,
              style: GoogleFonts.playfairDisplay(fontSize: 42, color: kLightTextColor, fontWeight: FontWeight.bold, height: 1.2),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, delay: 200.ms),
            const SizedBox(height: 16),
            Text(
              "₹${product.price}",
              style: GoogleFonts.lato(fontSize: 24, color: kAccentColor, fontWeight: FontWeight.w600),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, delay: 300.ms),
            const SizedBox(height: 40),
            Html(
              data: product.description,
              style: {"body": Style(fontSize: FontSize(16.0), color: kLightTextColor.withOpacity(0.7), lineHeight: LineHeight.em(1.8))},
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, delay: 400.ms),
            const SizedBox(height: 40),
            _buildSection(
              "Specifications",
              Column(
                children: [
                  _SpecRow("Category", product.category?.name.capitalize() ?? "N/A"),
                  _SpecRow("Purity", product.pricingBreakup?.components.isNotEmpty ?? false ? (product.pricingBreakup!.components.first.component.contains("22") ? "22 Karat Gold" : "Gold") : "N/A"),
                  _SpecRow("Gross Weight", "${product.pricingBreakup?.components.first.weight ?? 'N/A'} gm"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (product.pricingBreakup != null)
              _buildSection(
                "Price Details",
                Column(
                  children: [
                    _PriceRow("Subtotal", "₹${product.pricingBreakup!.subtotal.toStringAsFixed(2)}"),
                    _PriceRow("Labour Charges", "₹${product.pricingBreakup!.labourCharges.toStringAsFixed(2)}"),
                    _PriceRow("GST (${product.pricingBreakup!.gstPercentage.toStringAsFixed(1)}%)", "₹${product.pricingBreakup!.gstAmount.toStringAsFixed(2)}"),
                    Divider(height: 24, color: kLightTextColor.withOpacity(0.2)),
                    _PriceRow("Grand Total", "₹${product.pricingBreakup!.grandTotal.toStringAsFixed(2)}", isTotal: true),
                  ],
                ),
              ),
            const SizedBox(height: 40),

            // --- MODIFIED: Add to Bag Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: kBackgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                onPressed: _isAddingToCart ? null : _handleAddToCart,
                child: _isAddingToCart
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: kBackgroundColor),
                )
                    : const Text("ADD TO BAG"),
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, delay: 600.ms),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    // This widget remains unchanged
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(color: kLightTextColor, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        content,
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, delay: 500.ms);
  }

  Widget _buildCustomBackButton(BuildContext context) {
    // This widget remains unchanged
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 15,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(color: kBackgroundColor.withOpacity(0.3), shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Helper Widgets (No Changes) ---
class _SpecRow extends StatelessWidget {
  final String title;
  final String value;
  const _SpecRow(this.title, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.lato(color: kLightTextColor.withOpacity(0.7), fontSize: 15)),
          Text(value, style: GoogleFonts.lato(color: kLightTextColor, fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;
  const _PriceRow(this.title, this.value, {this.isTotal = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.lato(color: kLightTextColor.withOpacity(0.7), fontSize: 14)),
          Text(value, style: GoogleFonts.lato(color: isTotal ? kAccentColor : kLightTextColor, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, fontSize: isTotal ? 18 : 15)),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}