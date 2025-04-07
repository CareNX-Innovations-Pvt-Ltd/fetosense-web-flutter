import 'package:intl/intl.dart';

String formatDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '';
  try {
    final parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    return '';
  }
}
