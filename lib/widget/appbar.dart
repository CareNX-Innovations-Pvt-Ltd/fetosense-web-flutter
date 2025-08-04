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

PreferredSizeWidget buildAppBar(
    VoidCallback toggleSidebar,
    String userEmail,
    VoidCallback onLogout,
    ) {
  return AppBar(
    backgroundColor: const Color(0xFF181A1B),
    title: Image.asset('assets/images/login/fetosense.png', height: 30),
    leading: IconButton(
      key: const Key('toggleSidebarButton'),
      icon: Icon(Icons.menu, color: Colors.grey[600]),
      onPressed: toggleSidebar,
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: UserMenu(
          email: userEmail,
          onLogout: onLogout,
        ),
      ),
    ],
  );
}

class UserMenu extends StatelessWidget {
  final String email;
  final VoidCallback onLogout;

  const UserMenu({
    super.key,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(email, style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          key: const Key('userMenu'),
          icon: Icon(Icons.account_circle, color: Colors.grey[600]),
          onSelected: (value) {
            if (value == 'logout') onLogout();
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }
}
