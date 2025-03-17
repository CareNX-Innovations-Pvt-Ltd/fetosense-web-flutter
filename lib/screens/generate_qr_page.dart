import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  @override
  _GenerateQRPageState createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final TextEditingController kitIdController = TextEditingController();
  String? qrData; // Holds generated QR data

  void _generateQR() {
    setState(() {
      qrData = kitIdController.text.trim(); // Set the entered Kit ID as QR content
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Generate QR Code"),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Generate QR Code",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextField(
                controller: kitIdController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Kit ID *",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _generateQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: Text("Generate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 20),

              // Display QR Code if generated
              if (qrData != null && qrData!.isNotEmpty)
                Center(
                  child: Column(
                    children: [
                      QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text("QR Code for: $qrData",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
