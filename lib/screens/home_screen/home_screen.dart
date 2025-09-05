import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../about_screen/about_screen.dart';
import '../contact_screen/contact_screen.dart';
import '../privacy_policy_screen/privacy_policy_screen.dart';
import '../product_list_screen/product_list_screen.dart';
import '../return_policy_screen/return_policy_screen.dart';
import '../shipping_policy_screen/shipping_policy_screen.dart';
import '../terms_conditions_screen/terms_conditions_screen.dart';
import '../wishlist_screen/wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> featuredItems = [
    {
      'image': 'https://plus.unsplash.com/premium_photo-1674581215484-e6242a37c51e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Diamond Elegance',
      'description': 'Timeless beauty in every facet'
    },
    {
      'image': 'https://images.unsplash.com/photo-1564919783135-b9b75825aced?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Golden Radiance',
      'description': 'Pure luxury in 24K gold'
    },
    {
      'image': 'https://images.unsplash.com/photo-1632816307542-6a707d8a1c3c?q=80&w=996&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Emerald Dream',
      'description': 'Vibrant elegance for any occasion'
    },
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Rings', 'image': 'https://images.unsplash.com/photo-1599458349289-18f0ee82e6ed?q=80&w=689&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
    {'name': 'Necklaces', 'image': 'https://images.unsplash.com/photo-1708390250220-803af1100d31?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
    {'name': 'Bracelets', 'image': 'https://images.unsplash.com/photo-1549985620-caf66ebf912a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
    {'name': 'Earrings', 'image': 'https://images.unsplash.com/photo-1673285743108-75abe80e7bc1?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
  ];

  final gradient = LinearGradient(
    begin: Alignment.topCenter,
      end: Alignment.centerLeft,
      colors: [
        Color(0xffebd197),
        Color(0xffb48811),
        Color(0xffebd197)

  ]);

  final textStyle = TextStyle(
      fontSize: 27,
      color: Color(0xFF8B6B3A),
      fontWeight: FontWeight.bold,
      shadows: [
        BoxShadow(
            color: Colors.black,
            spreadRadius: 30,
            offset: Offset(1, 1)
        )
      ]
  );

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  bool _isUserInteracting = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );

    // Start auto-scroll timer
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isUserInteracting && mounted) {
        _currentPage = (_currentPage + 1) % featuredItems.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Already on Home screen
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductListScreen() ));
      // Navigate to Shop screen (placeholder)
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WishlistScreen() ));
      // Navigate to Wishlist screen (placeholder)
        break;
      case 3:
      // Navigate to Profile screen (placeholder)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
          },
          child: Text(
            'SK Ornaments',
            style: textStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFD4AF37), size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFD4AF37), size: 28),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildNavigationDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Banner
            _buildHeroBanner(),
            const SizedBox(height: 24),

            // Featured Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Featured Collections',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B6B3A),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 320,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _isUserInteracting = true;
                  } else if (notification is ScrollEndNotification) {
                    _isUserInteracting = false;
                    _currentPage = _pageController.page?.round() ?? 0;
                  }
                  return true;
                },
                child: PageView.builder(
                  itemCount: featuredItems.length,
                  itemBuilder: (context, index) {
                    return _buildFeaturedCard(
                      image: featuredItems[index]['image']!,
                      title: featuredItems[index]['title']!,
                      description: featuredItems[index]['description']!,
                    );
                  },
                  controller: _pageController,
                  padEnds: true,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Shop by Category',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B6B3A),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(
                    name: categories[index]['name']!,
                    image: categories[index]['image']!,
                  );
                },
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: const Color(0xFF8B6B3A).withOpacity(0.6),
        backgroundColor: const Color(0xFFFFF9F0),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 0 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 1 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.category),
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 2 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.favorite_border),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: _selectedIndex == 3 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.person_outline),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFFF9F0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1586950741480-13caae293cd8?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const CircleAvatar(
                  //   radius: 30,
                  //   backgroundColor: Colors.white,
                  //   child: Icon(Icons.person, size: 40, color: Color(0xFFD4AF37)),
                  // ),
                  const SizedBox(height: 12),
                  Text(
                    'SK Ornaments',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Tradition In Trust',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.contact_mail,
              title: 'Contact Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.category,
              title: 'Shop',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductListScreen()),
                );
                setState(() {
                  _selectedIndex = 1;
                });
                // Add shop navigation logic
              },
            ),
            const Divider(color: Color(0xFFD4AF37), thickness: 0.5),
            _buildDrawerItem(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistScreen()),
                );
                setState(() {
                  //_selectedIndex = 2;
                });
                // Add wishlist navigation logic
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                });
                // Add settings navigation logic
              },
            ),

            _buildDrawerItem(
              icon: Icons.local_shipping_outlined,
              title: 'Shipping Policy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShippingPolicyScreen()),
                );
                setState(() {
                  //_selectedIndex = 3;
                });
                // Add settings navigation logic
              },
            ),

            _buildDrawerItem(
              icon: Icons.class_,
              title: 'Terms & Conditions',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
                );
                setState(() {
                  //_selectedIndex = 3;
                });
                // Add settings navigation logic
              },
            ),

            _buildDrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy & Policy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
                setState(() {
                  //_selectedIndex = 3;
                });
                // Add settings navigation logic
              },
            ),

            _buildDrawerItem(
              icon: Icons.keyboard_return,
              title: 'Return Policy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReturnPolicyScreen()),
                );
                setState(() {
                  //_selectedIndex = 3;
                });
                // Add settings navigation logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD4AF37), size: 26),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8B6B3A),
        ),
      ),
      onTap: onTap,
      hoverColor: const Color(0xFFD4AF37).withOpacity(0.1),
    );
  }

  Widget _buildHeroBanner() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1728647771865-636b715674f4?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Text(
                'Discover Timeless Luxury',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  // Navigate to shop or featured collection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Shop Now',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard({
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({required String name, required String image}) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: () {
        setState(() {
          _selectedIndex = 1;
        });
        // Navigate to category-specific screen
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD4AF37), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Center(
                child: Text(
                  name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}