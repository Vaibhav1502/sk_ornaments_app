import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/contact_model/contact_model.dart';
import '../../services/contact_service/contact_service.dart';

const Color kAccentColor = Color(0xFFC09E6F);

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  ContactModel? contact;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContact();
  }

  Future<void> loadContact() async {
    final details = await ContactService.fetchContactDetails();
    setState(() {
      contact = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), // Soft ivory
      body: isLoading
          ?  Center(child: SpinKitFoldingCube(color:  kAccentColor,))
          : contact == null
          ? const Center(child: Text("Failed to load contact details"))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner image
            Stack(
              children: [
                Image.network(
                  "https://staging.skornaments.com/assets/img/logo/logo.jpg",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent
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
                  child: Text(
                    contact!.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Contact rows
            buildLuxuryContactRow(
              icon: Icons.location_on,
              text: contact!.address,
            ),
            buildLuxuryContactRow(
              icon: Icons.phone,
              text: contact!.phone,
            ),
            buildLuxuryContactRow(
              icon: Icons.email,
              text: contact!.email,
            ),
            buildLuxuryContactRow(
              icon: Icons.access_time,
              text: contact!.workingHours,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildLuxuryContactRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37).withOpacity(0.15),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
