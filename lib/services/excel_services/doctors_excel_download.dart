import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:appwrite/models.dart' as models;

class ExcelExportService {
  static Future<void> exportDoctorsToExcel(
    BuildContext context,
    List<models.Document> documents,
  ) async {
    try {
      // Get default created workbook and "Sheet1"
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Sheet1']!;

      // Add headers
      sheet.appendRow([
        'Name',
        'Email',
        'Organization',
        'Mother',
        'Test',
        'CreatedOn',
        'L.O.T',
        'Version',
      ]);

      // Add data rows
      for (var doc in documents) {
        final data = doc.data;
        // final address =
        //     '${data['addressLine'] ?? ''}, ${data['city'] ?? ''}, ${data['state'] ?? ''}, ${data['country'] ?? ''}';

        sheet.appendRow([
          data['name'] ?? '',
          data['email']?.toString() ?? '',
          data['organizationName']?.toString() ?? '',
          data['noOfMother']?.toString() ?? '',
          data['noOfTests']?.toString() ?? '',
          data['createdOn'] ?? '',
          data['lastLoginTime'] ?? '',
          data['appVersion'] ?? '',
        ]);
      }

      // Encode and trigger download
      final fileBytes = excel.encode();
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute("download", "Doctors.xlsx")
            ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
    }
  }
}
