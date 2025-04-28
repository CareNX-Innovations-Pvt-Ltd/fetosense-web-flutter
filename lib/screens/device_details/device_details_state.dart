part of 'device_details_cubit.dart';


class DeviceDetailsState {
  final List<models.Document> allDevices;
  final List<models.Document> filteredDevices;
  final bool isLoading;
  final String errorMessage;
  final DateTime? fromDate;
  final DateTime? tillDate;
  final String searchQuery;

  DeviceDetailsState({
    required this.allDevices,
    required this.filteredDevices,
    required this.isLoading,
    required this.errorMessage,
    required this.fromDate,
    required this.tillDate,
    required this.searchQuery,
  });

  factory DeviceDetailsState.initial() => DeviceDetailsState(
    allDevices: [],
    filteredDevices: [],
    isLoading: false,
    errorMessage: '',
    fromDate: null,
    tillDate: null,
    searchQuery: '',
  );

  DeviceDetailsState copyWith({
    List<models.Document>? allDevices,
    List<models.Document>? filteredDevices,
    bool? isLoading,
    String? errorMessage,
    DateTime? fromDate,
    DateTime? tillDate,
    String? searchQuery,
  }) {
    return DeviceDetailsState(
      allDevices: allDevices ?? this.allDevices,
      filteredDevices: filteredDevices ?? this.filteredDevices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      fromDate: fromDate ?? this.fromDate,
      tillDate: tillDate ?? this.tillDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

