import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/auth_models/login_model.dart'; // The User model is here
import '../../services/auth_service/auth_service.dart';
import '../auth/login_screen.dart'; // To navigate to on logout

// --- Using the "Serene Focus" / "Zen Gallery" theme ---
const Color kBackgroundColor = Color(0xFFF4F4F4);
const Color kPrimaryTextColor = Color(0xFF333333);
const Color kSecondaryTextColor = Color(0xFF888888);
const Color kAccentColor = Color(0xFFC4A47E);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = AuthService.getUserProfile();
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      // Navigate to login screen and clear all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("My Profile", style: GoogleFonts.playfairDisplay(color: kPrimaryTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        surfaceTintColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: kPrimaryTextColor),
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitFoldingCube(color: kAccentColor,));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: kSecondaryTextColor)));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Could not load profile.", style: TextStyle(color: kSecondaryTextColor)));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 40),
                _buildInfoSection(user),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.redAccent.withOpacity(0.3))
                    ),
                  ),
                  child: const Text("Logout",style: TextStyle(fontSize: 16),),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: kAccentColor,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            style: GoogleFonts.playfairDisplay(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryTextColor),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: GoogleFonts.lato(fontSize: 16, color: kSecondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildInfoSection(User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.phone_outlined, "Phone Number", user.phone ?? "Not provided"),
          const Divider(height: 32),
          _buildInfoRow(Icons.home_outlined, "Address", user.address ?? "Not provided"),
          const Divider(height: 32),
          _buildInfoRow(Icons.verified_user_outlined, "Role", user.role?.capitalize() ?? "User"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: kAccentColor, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.lato(color: kSecondaryTextColor, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.lato(color: kPrimaryTextColor, fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        )
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}