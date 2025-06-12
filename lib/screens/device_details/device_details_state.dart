part of 'device_details_cubit.dart';

/// State class for the device details screen.
///
/// Holds all device data, filtered device data, loading and error states, date filters, and search query.
/// Used by [DeviceDetailsCubit] to manage the UI state for device details.
class DeviceDetailsState {
  /// List of all device documents fetched from Appwrite.
  final List<models.Document> allDevices;

  /// List of devices after applying filters and search.
  final List<models.Document> filteredDevices;

  /// Whether device data is currently being loaded.
  final bool isLoading;

  /// Error message, if any, during data fetching or processing.
  final String errorMessage;

  /// The start date filter for device data.
  final DateTime? fromDate;

  /// The end date filter for device data.
  final DateTime? tillDate;

  /// The current search query for filtering devices.
  final String searchQuery;

  /// Creates a [DeviceDetailsState] with the given values.
  DeviceDetailsState({
    required this.allDevices,
    required this.filteredDevices,
    required this.isLoading,
    required this.errorMessage,
    required this.fromDate,
    required this.tillDate,
    required this.searchQuery,
  });

  /// Returns the initial state for device details.
  factory DeviceDetailsState.initial() => DeviceDetailsState(
    allDevices: [],
    filteredDevices: [],
    isLoading: false,
    errorMessage: '',
    fromDate: null,
    tillDate: null,
    searchQuery: '',
  );

  /// Returns a copy of this state with updated fields if provided.
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
