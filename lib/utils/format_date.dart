import 'package:intl/intl.dart';

/// Formats an ISO 8601 date string into a human-readable date format.
///
/// Takes an ISO 8601 formatted date string (e.g., `yyyy-MM-ddTHH:mm:ssZ`) and converts it
/// into a user-friendly format (e.g., `dd/MM/yyyy`). If the input date string is null, empty,
/// or invalid, it returns an empty string.
///
/// [isoDate]: The ISO 8601 date string to format.
///
/// Returns a formatted date string in the format `dd/MM/yyyy`, or an empty string if invalid.
String formatDate(String? isoDate) {
  // Return empty string if input is null or empty
  if (isoDate == null || isoDate.isEmpty) return '';
  try {
    // Parse the ISO 8601 date string
    final parsedDate = DateTime.parse(isoDate);
    // Format the parsed date into a user-friendly string
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    // If an error occurs during parsing, return an empty string
    return '';
  }
}
