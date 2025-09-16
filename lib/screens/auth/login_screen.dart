import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skornament/screens/auth/register_screen.dart';
import 'package:skornament/screens/onboarding_screen/onboarding_screen.dart';
import '../../services/auth_service/auth_service.dart';


const Color kLoginBackgroundColor = Color(0xFF2D2D2D);
const Color kPrimaryTextColorLight = Colors.white;
const Color kSecondaryTextColorLight = Colors.white70;
const Color kAccentColor = Color(0xFFC4A47E);
const Color kButtonColor = Color(0xFFe5e5e5);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await AuthService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      } catch (e) {
        setState(() => _errorMessage = e.toString().replaceFirst("Exception: ", ""));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLoginBackgroundColor,
      body: Stack(
        children: [
          // Layer 1: The Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back45.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Layer 2: The Dark Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Layer 3: The Login Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Welcome Back",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryTextColorLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Sign in to continue your journey.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: kSecondaryTextColorLight,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(label: "Email Address", icon: Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        decoration: _buildInputDecoration(label: "Password", icon: Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Error Message Display
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 20,fontWeight: FontWeight.bold),
                           // style: const TextStyle(color: Color(0xFFFFA0A0), fontSize: 20),
                          ),
                        ),

                      // Login Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed:  _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentColor,
                            foregroundColor: kButtonColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 24, width: 24,
                            child: SpinKitFadingCircle(size: 18, color: kButtonColor),
                          )
                              : const Text("LOGIN"),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: kSecondaryTextColorLight,fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for input decoration, styled for a dark background
  InputDecoration _buildInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kSecondaryTextColorLight, size: 20),
      labelStyle: const TextStyle(color: kSecondaryTextColorLight),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      // Style for the border when the field is not focused
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      // Style for the border when the field is focused
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kAccentColor, width: 2),
      ),
      // Style for error border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFA0A0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFA0A0), width: 2),
      ),
    );
  }
}