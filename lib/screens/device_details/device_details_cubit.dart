import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart'
    show ExcelExportService;

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
  }

  /// Fetches device data from Appwrite and updates the state.
  ///
  /// Applies the current date filters and search query.
  Future<void> fetchDeviceData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final devices = await fetchDevices(
        _db,
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
      applySearch(state.searchQuery); // Apply search after fetch
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Updates the from-date filter and emits the new state.
  void updateFromDate(DateTime? date) {
    emit(state.copyWith(fromDate: date));
  }

  /// Updates the till-date filter and emits the new state.
  void updateTillDate(DateTime? date) {
    emit(state.copyWith(tillDate: date));
  }

  /// Applies the search query to the device list and emits the new state.
  void applySearch(String query) {
    final keyword = query.trim().toLowerCase();
    final filtered =
        keyword.isEmpty
            ? state.allDevices
            : state.allDevices.where((device) {
              final name =
                  (device.data['organizationName'] ?? '')
                      .toString()
                      .toLowerCase();
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
}
