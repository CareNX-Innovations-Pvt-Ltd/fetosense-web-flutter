import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/excel_services.dart'
    show ExcelExportService;

import '../../utils/fetch_devices.dart';

part 'device_details_state.dart';

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  DeviceDetailsCubit() : super(DeviceDetailsState.initial());

  final _db = Databases(locator<AppwriteService>().client);

  void init() {
    fetchDeviceData();
  }

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

      ///
      applySearch(state.searchQuery); // Apply search after fetch
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void updateFromDate(DateTime? date) {
    emit(state.copyWith(fromDate: date));
  }

  void updateTillDate(DateTime? date) {
    emit(state.copyWith(tillDate: date));
  }

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
