import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(VoidCallback toggleSidebar, String userEmail) {
  return AppBar(
    backgroundColor: Colors.black54, // Adjust color as needed
    leading: Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/login/fetosense.png',
            height: 30, // Adjust image size as needed
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.grey[600]),
            onPressed: toggleSidebar, // ✅ Function to toggle sidebar
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            Text(
              userEmail,
              style: TextStyle(color: Colors.white),
            ), // ✅ User Email
            SizedBox(width: 8),
            Icon(
              Icons.account_circle,
              color: Colors.grey[600],
            ), // ✅ Account Circle Icon
          ],
        ),
      ),
    ],
  );
}
