import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skornament/screens/home_screen/home_screen.dart';

// Import your main product list screen to navigate to it
import '../product_list_screen/product_list_screen.dart';

// --- Using the "Serene Focus" theme ---
const Color kBackgroundColor = Color(0xFFF4F4F4);
const Color kPrimaryTextColor = Color(0xFF333333);
const Color kSecondaryTextColor = Color(0xFF888888);
const Color kAccentColor = Color(0xFFC4A47E);
const Color kButtonColor = Color(0xFF333333);

// Data structure for our onboarding pages
class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_1.jpg',
      title: 'Exquisite Craftsmanship',
      description:
          'Discover unique pieces, meticulously crafted to last a lifetime. A legacy of beauty in every detail.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_2.jpg',
      title: 'Timeless Elegance',
      description:
          'Explore curated collections that transcend trends. Find the perfect expression of your personal style.',
    ),
    OnboardingPageData(
      imagePath: 'assets/images/onboarding_3.jpg',
      title: 'A Trusted Experience',
      description:
          'Enjoy secure shopping and dedicated support on your journey to find the perfect piece.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _navigateToHome() {
    // Navigate to your main app screen and remove the onboarding screen from the stack
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(pageData: _pages[index]);
            },
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 8,
                    width: _currentPage == index ? 32 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                          _currentPage == index
                              ? kAccentColor
                              : kSecondaryTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),

              // Bottom Buttons
              SizedBox(
                height: 50,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child:
                      _currentPage == _pages.length - 1
                          ? _buildGetStartedButton()
                          : _buildNextButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _navigateToHome,
          child: Text(
            'Skip',
            style: GoogleFonts.lato(color: kSecondaryTextColor, fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          style: IconButton.styleFrom(
            backgroundColor: kButtonColor,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
        ),
      ],
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: _navigateToHome,
        child: const Text("Explore the Collection"),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData pageData;
  const _OnboardingPage({required this.pageData});

  @override
  Widget build(BuildContext context) {
    // We use a ValueKey to ensure animations re-run when the page changes
    return Container(
      key: ValueKey(pageData.title),
      child: Column(
        children: [
          // Image takes up the top 60% of the screen
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pageData.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Text content takes up the bottom 40%
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pageData.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pageData.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: kSecondaryTextColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Give some space for the bottom controls
          const SizedBox(height: 120),
        ],
      ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOutCubic),
    );
  }
}
