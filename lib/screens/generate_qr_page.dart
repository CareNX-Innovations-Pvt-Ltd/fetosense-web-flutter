import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Generate QR Code",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white),
              const SizedBox(height: 20),

              // Kit ID Field
              _buildLabel("Kit ID", true),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _kitIdController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: _inputDecoration("Enter Kit ID"),
                  validator:
                      (value) =>
                          value == null || value.trim().isEmpty
                              ? "Kit ID is required"
                              : null,
                  onChanged: (value) {
                    if (value.startsWith(' ')) {
                      _kitIdController.text = value.trimLeft();
                      _kitIdController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _kitIdController.text.length),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _handleGenerate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Generate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // QR Display
              if (_showQR) const SizedBox(height: 32),
              if (_showQR) _buildQRSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRSection() {
    return Column(
      children: [
        const Text(
          "Share this QR Code",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 16),
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: QrImageView(data: _qrData, size: _qrWidth.toDouble()),
          ),
        ),
        const SizedBox(height: 16),
        if (_showKitId)
          Text(
            "Kit ID: $_kitId",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _showKitId,
              onChanged: (val) => setState(() => _showKitId = val ?? false),
            ),
            const Text("Show Kit ID", style: TextStyle(color: Colors.white)),
            const SizedBox(width: 12),
            IconButton(
              onPressed: _downloadQR,
              icon: const Icon(Icons.download, color: Colors.green),
              tooltip: "Download QR Code",
            ),
          ],
        ),
      ],
    );
  }

  void _handleGenerate() {
    if (_formKey.currentState!.validate()) {
      final trimmed = _kitIdController.text.trim();
      setState(() {
        _qrData = "FETOSENSE:${base64Encode(utf8.encode(trimmed))}";
        _kitId = trimmed;
        _showQR = true;
      });
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
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
