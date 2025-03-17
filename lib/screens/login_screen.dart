import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Client client;
  LoginScreen({required this.client});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String message = "";

  void loginUser() async {
    try {
      await AuthService(widget.client)
          .loginUser(usernameController.text, passwordController.text);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        message = "Login failed. Please check credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: 850,
          height: 400,
          decoration: BoxDecoration(
            color: Color(0xFF252525),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              // fontWeight: FontWeight.bold
                              )),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF252525),
                          prefixIcon: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // White separator line
                                  width: 1, // Thickness of separator
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.person, color: Colors.white), // White-bordered icon
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.white), // White outer border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.white), // White outer border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.cyanAccent), // Highlight color on focus
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF252525),
                          prefixIcon: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // White separator line
                                  width: 1.5, // Thickness of separator
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.lock, color: Colors.white), // White-bordered icon
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.white), // White outer border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.white), // White outer border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.cyanAccent), // Highlight color on focus
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                            activeColor: Colors.blue,
                          ),
                          Text("I'm not a robot",
                              style: TextStyle(color: Colors.white54)),
                          Spacer(),
                          Icon(Icons.security, color: Colors.white54),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
  width: 100,
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.cyan[700],
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Makes button corners square
      ),
    ),
    child: Text("Login",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  ),
),

                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(24.0),
                  color: Color(0xFF252525),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
  'assets/images/login/fetosense.png',  // Remove the extra `/` at the beginning
  height: 80,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
  },
),

                      SizedBox(height: 20),
                      SizedBox(height: 10),
                      Text(
                        "Fetosense - India's most advanced product for Fetal Heart Monitoring",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
  width: 100,
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.cyan[700],
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Makes button corners square
      ),
    ),
    child: Text("Home Page",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  ),
),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
