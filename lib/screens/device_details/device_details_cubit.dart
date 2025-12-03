import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/models/test_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart'
    show ExcelExportService;
import 'package:fetosense_mis/core/utils/app_constants.dart';

import '../../utils/fetch_devices.dart';

part 'device_details_state.dart';

/// Cubit for managing the state and logic of the device details screen.
///
/// Handles fetching, filtering, and searching device data from Appwrite,
/// as well as updating date filters and managing loading/error states.
class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  /// Creates a [DeviceDetailsCubit] and initializes the state.
  DeviceDetailsCubit() : super(DeviceDetailsState.initial());

  /// Appwrite [Databases] instance for device data operations.
  final _db = Databases(locator<AppwriteService>().client);

  /// Initializes the cubit by fetching device data.
  void init() {
    fetchDeviceData();
    computeDeviceStats();
    fetchMothersPerDevice();
  }

  /// Fetches device data from Appwrite and updates the state.
  ///
  /// Applies the current date filters and search query.
  Future<void> fetchDeviceData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final devices = await _fetchDevicesLocal(
        fromDate: state.fromDate,
        tillDate: state.tillDate,
      );

      emit(
        state.copyWith(
          allDevices: devices,
          filteredDevices: devices,
          isLoading: false,
        ),
      );

      applySearch(state.searchQuery);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<List<models.Document>> _fetchDevicesLocal({
    DateTime? fromDate,
    DateTime? tillDate,
  }) async {
    final res = await fetchDevices(_db, fromDate: null, tillDate: null);

    if (fromDate == null && tillDate == null) return res;

    final from =
        fromDate != null
            ? DateTime(fromDate.year, fromDate.month, fromDate.day, 0, 0, 0)
            : null;

    final till =
        tillDate != null
            ? DateTime(
              tillDate.year,
              tillDate.month,
              tillDate.day,
              23,
              59,
              59,
              999,
            )
            : null;

    return res.where((doc) {
      DateTime? created;

      final createdOn = doc.data['createdOn'];
      if (createdOn is String) created = DateTime.tryParse(createdOn);
      if (createdOn is int)
        created = DateTime.fromMillisecondsSinceEpoch(createdOn);

      created ??= DateTime.tryParse(doc.$createdAt);

      if (created == null) return false;

      if (from != null && created.isBefore(from)) return false;
      if (till != null && created.isAfter(till)) return false;

      return true;
    }).toList();
  }

  /// Updates the from-date filter and emits the new state.
  void updateFromDate(DateTime? date) {
    emit(state.copyWith(fromDate: date, overrideFromDate: true));
  }

  /// Updates the till-date filter and emits the new state.
  void updateTillDate(DateTime? date) {
    emit(state.copyWith(tillDate: date, overrideTillDate: true));
  }

  /// Clears all filters and refreshes device data.
  void clearAllFilters() {
    emit(
      state.copyWith(
        fromDate: null,
        overrideFromDate: true,
        tillDate: null,
        overrideTillDate: true,
      ),
    );

    Future.microtask(() => fetchDeviceData());
  }

  /// Applies the search query to the device list and emits the new state.
  void applySearch(String query) {
    final keyword = query.trim().toLowerCase();
    final filtered =
        keyword.isEmpty
            ? state.allDevices
            : state.allDevices.where((device) {
              final name =
                  (device.data['deviceName'] ?? '').toString().toLowerCase();
              return name.contains(keyword);
            }).toList();

    emit(state.copyWith(searchQuery: query, filteredDevices: filtered));
  }

  /// Downloads the filtered device data as an Excel file.
  Future<void> downloadExcel(context) async {
    try {
      await ExcelExportService.exportDevicesToExcel(
        context,
        state.filteredDevices,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> computeDeviceStats() async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.testsCollectionId,
      // queries: [Query.limit(5000)],
    );

    final tests =
        result.documents.map((doc) => Test.fromMap(doc.data, doc.$id)).toList();

    print('Total tests fetched: ${tests.length}');

    final Map<String, int> testCounts = {};

    for (var t in result.documents) {
      final data = t.data;
      final deviceId = data['deviceName'];

      if (deviceId == null || deviceId.isEmpty) continue;

      testCounts[deviceId] = (testCounts[deviceId] ?? 0) + 1;
    }

    emit(state.copyWith(testsPerDevice: testCounts));
  }

  Future<void> fetchMothersPerDevice() async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.userCollectionId,
      queries: [Query.equal('type', 'mother')],
    );

    final Map<String, int> mothersCount = {};

    print('Total mothers fetched: ${result.documents.length}');

    for (var doc in result.documents) {
      final data = doc.data;
      final deviceId = data['deviceName'];

      if (deviceId == null || deviceId.isEmpty) continue;

      mothersCount[deviceId] = (mothersCount[deviceId] ?? 0) + 1;
    }

    emit(state.copyWith(mothersPerDevice: mothersCount));
  }
}
