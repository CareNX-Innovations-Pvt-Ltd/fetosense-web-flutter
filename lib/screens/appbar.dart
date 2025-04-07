import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(VoidCallback toggleSidebar, String userEmail) {
  return AppBar(
    backgroundColor: Colors.black54,
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
            Text(userEmail, style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.account_circle, color: Colors.grey[600]),
          ],
        ),
      ),
    ],
  );
}
