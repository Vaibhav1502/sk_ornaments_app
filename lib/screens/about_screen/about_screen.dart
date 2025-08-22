import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/about_model/abou_model.dart';
import '../../services/about_service/about_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<AboutData> aboutData;

  @override
  void initState() {
    super.initState();
    aboutData = AboutService().fetchAboutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), // Light ivory background
      body: FutureBuilder<AboutData>(
        future: aboutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final about = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner Image
                Stack(
                  children: [
                    Image.network(
                      "https://plus.unsplash.com/premium_photo-1675107359827-6de8bcf03ccf?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Jewelry banner
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
                  ],
                ),

                const SizedBox(height: 20),

                // Title always at top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    about.title, // Always "About Us"
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: const Color(0xFF8B6B3A),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // About Us Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildGoldCard(
                    icon: Icons.diamond_outlined,
                    title: "About Us",
                    content: about.content,
                  ),
                ),

                const SizedBox(height: 20),

                // Mission Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildGoldCard(
                    icon: Icons.flag_rounded,
                    title: "Our Mission",
                    content: about.mission,
                  ),
                ),

                const SizedBox(height: 20),

                // Vision Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildGoldCard(
                    icon: Icons.remove_red_eye_rounded,
                    title: "Our Vision",
                    content: about.vision,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildGoldCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4AF37), width: 1.5), // Gold border
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFFD4AF37)),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: const Color(0xFF8B6B3A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 15,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}