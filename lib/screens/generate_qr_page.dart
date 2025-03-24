import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Custom widgets
import 'sidebar.dart';
import 'appbar.dart';
import 'bottom_navigation_bar.dart';

class GenerateQRPage extends StatefulWidget {
  @override
  _GenerateQRPageState createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kitIdController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();

  bool _showQR = false;
  bool _showKitId = false;
  String _qrData = '';
  String _kitId = '';
  int _qrWidth = 200;
  bool _isSidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() => _isSidebarCollapsed = !_isSidebarCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: buildAppBar(_toggleSidebar, "User"),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (!_isSidebarCollapsed)
                  buildSidebar(context, () {
                    // logout logic
                  }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Form
                          Expanded(
                            child: Card(
                              color: const Color(0xFF2A2A2A),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: "Generate ",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: "QR Code",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Kit ID *',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _kitIdController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFF1E1E1E),
                                        hintText: 'Enter kit id',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Kit ID is required';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        if (value.startsWith(' ')) {
                                          _kitIdController.text =
                                              value.trimLeft();
                                          _kitIdController.selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset:
                                                      _kitIdController
                                                          .text
                                                          .length,
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0B75C9,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final trimmed =
                                              _kitIdController.text.trim();
                                          setState(() {
                                            _qrData =
                                                "FETOSENSE:${base64Encode(utf8.encode(trimmed))}";
                                            _kitId = trimmed;
                                            _showQR = true;
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Text("Generate"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Right QR Card
                          if (_showQR) const SizedBox(width: 24),
                          if (_showQR)
                            Expanded(
                              child: Card(
                                color: const Color(0xFF2A2A2A),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Share this QR Code",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      RepaintBoundary(
                                        key: _qrKey,
                                        child: Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(8),
                                          child: QrImageView(
                                            data: _qrData,
                                            size: _qrWidth.toDouble(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (_showKitId)
                                        Text(
                                          "Kit ID: $_kitId",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: _showKitId,
                                            onChanged:
                                                (val) => setState(
                                                  () =>
                                                      _showKitId = val ?? false,
                                                ),
                                          ),
                                          const Text(
                                            "Show Kit ID",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            onPressed: _downloadQR,
                                            icon: const Icon(
                                              Icons.download,
                                              color: Colors.green,
                                            ),
                                            tooltip: "Download QR Code",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const BottomNavBar(), // ✅ Full width bottom nav
        ],
      ),
    );
  }

  Future<void> _downloadQR() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute('download', '$_kitId QR_Code.png')
            ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Download Error: $e');
    }
  }
}
