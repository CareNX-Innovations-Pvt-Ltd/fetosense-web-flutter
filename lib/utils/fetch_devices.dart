import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

Future<List<models.Document>> fetchDevices(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  try {
    final List<String> queries = [Query.equal('type', 'device')];

    final bool applyDateFilter = fromDate != null || tillDate != null;

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
      databaseId: '67e14dc00025fa9f71ad', // your DB ID
      collectionId: '67e293bc001845f81688', // your Devices collection ID
      queries: queries,
    );

    return result.documents;
  } catch (e) {
    print('❌ Error fetching devices: $e');
    return [];
  }
}
