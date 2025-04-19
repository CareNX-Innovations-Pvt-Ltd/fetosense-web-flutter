import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:appwrite/models.dart' as models;

/// A service for exporting device data to an Excel file.
///
/// The `ExcelExportService` class provides a method to export device data
/// (represented as a list of Appwrite documents) into an Excel file. The
/// Excel file is then made available for download by the user in `.xlsx` format.
class ExcelExportService {
  /// Exports the given list of [documents] to an Excel file and triggers
  /// the download.
  ///
  /// The method creates a new Excel file, adds headers and rows based on the
  /// given device data, and then triggers a download of the generated Excel file.
  ///
  /// [context] is required to show any error messages if the export fails.
  /// [documents] is a list of Appwrite [Document] objects containing the
  /// device data to be exported.
  ///
  /// This method handles the creation of the Excel file and ensures the file
  /// is downloaded in the user's browser.
  static Future<void> exportDevicesToExcel(
    BuildContext context,
    List<models.Document> documents,
  ) async {
    try {
      // Create a new Excel file and select the first sheet
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Sheet1']!;

      // Add headers to the sheet
      sheet.appendRow([
        'Doppler Number',
        'Device Code',
        'Organization',
        'Mother',
        'Test',
        'CreatedOn',
        'Version',
      ]);

      // Add data rows based on the documents provided
      for (var doc in documents) {
        final data = doc.data;

        sheet.appendRow([
          data['deviceName'] ?? '',
          data['deviceCode']?.toString() ?? '',
          data['organizationName']?.toString() ?? '',
          data['noOfMother']?.toString() ?? '',
          data['noOfTests']?.toString() ?? '',
          data['createdOn'] ?? '',
          data['appVersion'] ?? '',
        ]);
      }

      // Encode the Excel file and prepare it for download
      final fileBytes = excel.encode();
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
          html.AnchorElement(href: url)
            ..setAttribute("download", "Devices.xlsx")
            ..click(); // Trigger the download
      html.Url.revokeObjectUrl(url); // Clean up the object URL after download
    } catch (e) {
      // Show an error message if the export fails
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to export: $e")));
    }
  }
}
