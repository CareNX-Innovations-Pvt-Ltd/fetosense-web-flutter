import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  // Function to launch a URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year; // ✅ Get current year dynamically

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.black54, // Background color
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Space elements properly
        children: [
          // Left Side: Company Name & Year
          Row(
            children: [
              // Copyright Icon
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => _launchURL("https://carenx.com/"), // Open URL
                child: Text(
                  "CareNX Innovations Pvt/Ltd.",
                  style: TextStyle(
                    color: Colors.cyan[600],
                    fontSize: 14,
                  ), // Cyan Link
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.copyright, color: Colors.white, size: 12),
              Text(
                "$currentYear",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ), // Current Year
            ],
          ),

          // Right Side: Version & Powered By
          Row(
            children: [
              const Text(
                "Version V1.1.1 Powered By ",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              GestureDetector(
                onTap: () => _launchURL("https://carenx.com/"), // Open URL
                child: Text(
                  "CareNX",
                  style: TextStyle(
                    color: Colors.cyan[600],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ), // Cyan Link
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
