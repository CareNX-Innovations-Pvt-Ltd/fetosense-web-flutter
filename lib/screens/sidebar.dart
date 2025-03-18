import 'package:flutter/material.dart';

Widget buildSidebar(BuildContext context, VoidCallback logoutCallback) {
  return Container(
    width: 250,
    color: Colors.grey[850],
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "fetosense",
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        _sidebarItem(
          Icons.dashboard,
          "Dashboard",
          onTap: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        _buildExpandableMenu(Icons.app_registration, "Registration", [
          _sidebarSubItem(
            context,
            "Organization",
            '/organization-registration',
          ),
          _sidebarSubItem(context, "Device", '/device-registration'),
          _sidebarSubItem(context, "Generate QR", '/generate-qr'),
        ]),
        _buildExpandableMenu(Icons.pie_chart, "MIS", [
          _sidebarSubItem(context, "Organizations", '/mis-organizations'),
          _sidebarSubItem(context, "Device", '/mis-devices'),
          _sidebarSubItem(context, "Doctor", '/mis-doctors'),
          _sidebarSubItem(context, "Mother", '/mis-mothers'),
          _sidebarSubItem(context, "Test", '/mis-tests'),
        ]),
        _sidebarItem(Icons.analytics, "Analytics"),
        _sidebarItem(Icons.article, "Reports"),
        _sidebarItem(Icons.settings, "Operations"),
        _sidebarItem(Icons.people, "Users"),
        Spacer(),
        _sidebarItem(Icons.logout, "Logout", onTap: logoutCallback),
      ],
    ),
  );
}

Widget _sidebarItem(IconData icon, String title, {VoidCallback? onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: TextStyle(color: Colors.white)),
    onTap: onTap,
  );
}

Widget _buildExpandableMenu(
  IconData icon,
  String title,
  List<Widget> children,
) {
  return Theme(
    data: ThemeData().copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      children: children,
    ),
  );
}

Widget _sidebarSubItem(BuildContext context, String title, String route) {
  return ListTile(
    title: Text(title, style: TextStyle(color: Colors.white)),
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}
