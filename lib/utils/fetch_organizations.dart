Future<void> _fetchOrganizations() async {
  try {
    List<Query> queries = [];

    if (fromDate != null) {
      queries.add(
        Query.greaterThanEqual('createdOn', fromDate!.toIso8601String()),
      );
    }
    if (tillDate != null) {
      queries.add(
        Query.lessThanEqual('createdOn', tillDate!.toIso8601String()),
      );
    }

    final result = await db.listDocuments(
      databaseId: '67e14dc00025fa9f71ad',
      collectionId: '67e293bc001845f81688',
      queries: queries,
    );

    setState(() {
      organizations = result.documents;
    });
  } catch (e) {
    print("Error fetching organizations: $e");
  }
}
