import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class LoginScreen extends StatefulWidget {
  final Client client; // Accepts Appwrite Client

  LoginScreen({required this.client});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = "";

  void loginUser() {
    print("Logging in with: ${usernameController.text}");
    setState(() {
      message = "Login attempt made! (Replace with real API call)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          width: 800,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade900, blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              // Left Side: Login Form
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          hintText: "Username",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Login",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text("Create an Account",
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right Side: Company Info
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
  'https://dummyimage.com/150x150/000/fff.png&text=Logo', // New placeholder
  height: 80,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
  },
),

                      SizedBox(height: 20),
                      Text(
                        "fetosense",
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Fetosense - India's most advanced product for Fetal Heart Monitoring",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text("Home Page"),
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
