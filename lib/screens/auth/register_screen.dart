import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service/auth_service.dart';
import 'login_screen.dart';


const Color kLoginBackgroundColor = Color(0xFF2D2D2D);
const Color kPrimaryTextColorLight = Colors.white;
const Color kSecondaryTextColorLight = Colors.white70;
const Color kAccentColor = Color(0xFFC4A47E);
const Color kButtonColor = Color(0xFFe5e5e5);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await AuthService.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          passwordConfirmation: _confirmPasswordController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        setState(
          () => _errorMessage = e.toString().replaceFirst("Exception: ", ""),
        );
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/back45.jpg',
              fit: BoxFit.cover,
            ),
          ),
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
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryTextColorLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Begin your journey with us today.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: kSecondaryTextColorLight,
                        ),
                      ),
                      const SizedBox(height: 40),

                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        decoration: _buildInputDecoration(
                          label: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        validator:
                            (v) => v!.isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          label: "Email Address",
                          icon: Icons.email_outlined,
                        ),
                        validator:
                            (v) =>
                                v!.isEmpty || !v.contains('@')
                                    ? 'Please enter a valid email'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                        ),
                        validator:
                            (v) =>
                                v!.isEmpty
                                    ? 'Please enter your phone number'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        decoration: _buildInputDecoration(
                          label: "Address",
                          icon: Icons.home_outlined,
                        ),
                        validator:
                            (v) =>
                                v!.isEmpty ? 'Please enter your address' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        decoration: _buildInputDecoration(
                          label: "Password",
                          icon: Icons.lock_outline,
                        ),
                        validator:
                            (v) =>
                                v!.length < 8
                                    ? 'Password must be at least 8 characters'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: kPrimaryTextColorLight),
                        decoration: _buildInputDecoration(
                          label: "Confirm Password",
                          icon: Icons.lock_outline,
                        ),
                        validator:
                            (v) =>
                                v != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                      ),
                      const SizedBox(height: 24),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentColor,
                            foregroundColor: kButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: SpinKitFadingCircle(
                                      size: 18,
                                      color: kButtonColor,
                                    ),
                                  )
                                  : const Text("SIGN UP"),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed:
                            () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                        child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(color: kSecondaryTextColorLight,fontSize: 16),
                        ),
                      ),
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

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    // Reusing the same beautiful decoration from the login screen
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kSecondaryTextColorLight, size: 20),
      labelStyle: const TextStyle(color: kSecondaryTextColorLight),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kAccentColor, width: 2),
      ),
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
