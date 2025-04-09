import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

Future<List<models.Document>> fetchDoctors(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  try {
    final List<String> queries = [Query.equal('type', 'doctor')];

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
    //for push
    final result = await db.listDocuments(
      databaseId: '67e14dc00025fa9f71ad',
      collectionId: '67e293bc001845f81688',
      queries: queries,
    );

    return result.documents;
  } catch (e) {
    print('❌ Error fetching doctors: $e');
    return [];
  }
}
