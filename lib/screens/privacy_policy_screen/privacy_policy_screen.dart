import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/privacy_policy_model/privacy_policy_model.dart';
import '../../services/privacy_policy_service/privacy_policy_service.dart';


// --- Using the "Zen Gallery" theme for a consistent, premium feel ---
const Color kBackgroundColor = Color(0xFFF7F5F2);
const Color kPrimaryTextColor = Color(0xFF8B6B3A);
const Color kSecondaryTextColor = Color(0xFF7D7D7D);
const Color kAccentColor = Color(0xFFC09E6F); // A soft, brushed gold
const Color kSubtleBackgroundColor = Color(0xFFFFFFFF);

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<PrivacyPolicyData> _policyFuture;

  @override
  void initState() {
    super.initState();
    _policyFuture = PrivacyPolicyService.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        surfaceTintColor: kBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<PrivacyPolicyData>(
        future: _policyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:  SpinKitFoldingCube(color: kAccentColor,));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: kSecondaryTextColor)));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No information found.", style: TextStyle(color: kSecondaryTextColor)));
          }

          final policyData = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(policyData.title),
                const SizedBox(height: 40),
                _buildHighlight(
                  icon: Icons.update_outlined,
                  label: "LAST UPDATED",
                  value: policyData.lastUpdated,
                ),
                const SizedBox(height: 40),
                Divider(color: kAccentColor.withOpacity(0.2)),
                const SizedBox(height: 40),
                _buildMainContent(policyData.content),
                const SizedBox(height: 40),
              ].animate(interval: 100.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 42,
          fontWeight: FontWeight.w600,
          color: kPrimaryTextColor,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildHighlight({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSubtleBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccentColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: kAccentColor, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: kSecondaryTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: kPrimaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Privacy Commitment",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Html(
          data: content,
          style: {
            "body": Style(
              fontSize: FontSize(16.0),
              color: kSecondaryTextColor,
              lineHeight: LineHeight.em(1.8),
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
          },
        ),
      ],
    );
  }
}