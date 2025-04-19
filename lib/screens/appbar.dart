import 'package:flutter/material.dart';

/// Builds the AppBar widget for the application.
///
/// The AppBar contains a logo, a menu button to toggle the sidebar,
/// and the user's email with an account icon in the actions section.
///
/// The [toggleSidebar] function is used to open/close the sidebar when the menu button is pressed.
/// The [userEmail] is the email address of the currently logged-in user and is displayed next to the account icon.
///
/// Returns a [PreferredSizeWidget] that is used to display the AppBar.

PreferredSizeWidget buildAppBar(VoidCallback toggleSidebar, String userEmail) {
  return AppBar(
    backgroundColor: const Color(0xFF181A1B),
    title: Image.asset('assets/images/login/fetosense.png', height: 30),
    leading: IconButton(
      icon: Icon(Icons.menu, color: Colors.grey[600]),
      onPressed: toggleSidebar,
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            /// Displays the email address of the currently logged-in user.
            Text(userEmail, style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),

            /// Icon representing the user's account.
            Icon(Icons.account_circle, color: Colors.grey[600]),
          ],
        ),
      ),
    ],
  );
}
