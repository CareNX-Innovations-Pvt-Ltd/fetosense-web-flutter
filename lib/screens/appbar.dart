import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(String userEmail, VoidCallback logoutCallback) {
  return AppBar(
    title: Text('Dashboard'),
    actions: [
      IconButton(icon: Icon(Icons.exit_to_app), onPressed: logoutCallback),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(userEmail),
      ),
    ],
  );
}
