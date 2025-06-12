import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

Future<List<models.Document>> fetchTests(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  try {
    final List<String> queries = [];

    final bool applyDateFilter = fromDate != null || tillDate != null;

    // If date filters are applied, add queries for createdOn field
    if (applyDateFilter) {
      queries.add(Query.isNotNull('createdOn'));

      if (fromDate != null) {
        queries.add(
          Query.greaterThanEqual('createdOn', fromDate.toIso8601String()),
        );
      }

      if (tillDate != null) {
        final tillDateEnd = DateTime(
          tillDate.year,
          tillDate.month,
          tillDate.day,
          23,
          59,
          59,
        );
        queries.add(
          Query.lessThanEqual('createdOn', tillDateEnd.toIso8601String()),
        );
      }
    }

    final result = await db.listDocuments(
      databaseId: '67ece4a7002a0a732dfd',
      collectionId: '67f3790a0024f8f61684',
      queries: queries,
    );

    return result.documents;
  } catch (e) {
    print('Error fetching tests: $e');
    return [];
  }
}
