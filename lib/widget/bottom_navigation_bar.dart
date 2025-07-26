import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A StatelessWidget that represents the Bottom Navigation Bar.
///
/// This widget contains two main sections:
/// 1. The left side displays the company name with the current year and a copyright icon.
/// 2. The right side displays the app version and "Powered by" information, with a clickable link to the company website.
///
/// The [BottomNavBar] widget also provides functionality to launch external URLs when the company name or "CareNX" is tapped.
///
/// The [currentYear] is dynamically fetched using the `DateTime.now().year` function to always show the current year.

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
    int currentYear = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color(0xFF181A1B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 5),
                Flexible(
                  child: GestureDetector(
                    onTap: () => _launchURL("https://carenx.com/"),
                    child: Text(
                      "CareNX Innovations Pvt/Ltd.",
                      style: TextStyle(
                        color: Colors.cyan[600],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.copyright, color: Colors.white, size: 12),
                Text(
                  "$currentYear",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          // Right Side
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Flexible(
                  child: Text(
                    "Version V1.1.1 Powered By ",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => _launchURL("https://carenx.com/"),
                  child: Text(
                    "CareNX",
                    style: TextStyle(
                      color: Colors.cyan[600],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
