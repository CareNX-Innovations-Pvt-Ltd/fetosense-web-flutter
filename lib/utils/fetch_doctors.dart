import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

/// Fetches a list of doctors from the Appwrite database.
///
/// This function queries the Appwrite database for documents in the specified
/// collection that match the criteria defined by the filters. It supports optional
/// date filters (`fromDate` and `tillDate`) to narrow the query results based on
/// the document creation date. It retrieves documents where the `type` field is
/// equal to 'doctor'.
///
/// [db] is the instance of the [Databases] used for querying the Appwrite database.
/// [fromDate] is the optional start date filter for the document creation date.
/// [tillDate] is the optional end date filter for the document creation date.
///
/// Returns a list of [models.Document] objects that match the query criteria.
/// In case of an error, an empty list is returned.
Future<List<models.Document>> fetchDoctors(
  Databases db, {
  DateTime? fromDate,
  DateTime? tillDate,
}) async {
  try {
    final List<String> queries = [Query.equal('type', 'doctor')];

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
        // Add a query to filter documents created on or before the end of tillDate
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

    // Fetch doctor documents from Appwrite database
    final result = await db.listDocuments(
      databaseId: '67ece4a7002a0a732dfd',
      collectionId: '67f36a7e002c46ea05f0',
      queries: queries,
    );

    // Return the list of doctor documents
    return result.documents;
  } catch (e) {
    // Print error and return empty list on failure
    print('Error fetching doctors: $e');
    return [];
  }
}
