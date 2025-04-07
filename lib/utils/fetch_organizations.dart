import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<models.Document>> fetchOrganizations(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  try {
    final List<String> queries = [Query.equal('type', 'organization')];

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
      databaseId: dotenv.env['FETOSENSE_DEVICE_DATABASE_ID']!,
      collectionId: dotenv.env['USERS_COLLECTION_ID']!,
      queries: queries,
    );

    return result.documents;
  } catch (e) {
    print('❌ Error fetching organizations: $e');
    return [];
  }
}
