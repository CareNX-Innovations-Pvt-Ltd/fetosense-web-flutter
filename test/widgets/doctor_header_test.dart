import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/services/excel_services.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/widgets/doctor_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorDetailsCubit extends Mock implements DoctorDetailsCubit {}

class MockDocument extends Mock implements models.Document {}

class MockExcelExportService extends Mock implements ExcelExportService {}

class MockBuildContext extends Mock implements BuildContext {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockBuildContext';
  }
}

void main() {
  late MockBuildContext context;
  late MockDoctorDetailsCubit cubit;
  late DoctorDetailsState state;
  late MockDocument doc;

  setUp(() {
    cubit = MockDoctorDetailsCubit();
    doc = MockDocument();
    context = MockBuildContext();

    when(() => doc.data).thenReturn({'doctorName': 'Dr. Strange'});
    when(() => cubit.state).thenReturn(
      DoctorDetailsState(
        allDoctors: [doc],
        filteredDoctors: [doc],
        fromDate: null,
        tillDate: null,
        isLoading: false,
        error: null,
      ),
    );
  });

  setUpAll(() {
    registerFallbackValue(BuildContext);
    registerFallbackValue(<models.Document>[]);
  });

  tearDown(() {
    reset(cubit);
  });

  group('DoctorDetailsHeader Widget', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const DoctorDetailsHeader(),
          ),
        ),
      );

      expect(find.text('Doctor Details'), findsOneWidget);
      expect(find.byIcon(Icons.apartment), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);
    });

    testWidgets('calls ExcelExportService.exportDoctorsToExcel successfully', (
      tester,
    ) async {
      // Mock static method
      bool called = false;
      ExcelExportService.exportDoctorsToExcel(context, []);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const Scaffold(body: DoctorDetailsHeader()),
          ),
        ),
      );

      final button = find.byIcon(Icons.download);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('shows SnackBar on export failure', (tester) async {
      ExcelExportService.exportDoctorsToExcel(context, []);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const Scaffold(body: DoctorDetailsHeader()),
          ),
        ),
      );

      final button = find.byIcon(Icons.download);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // SnackBar should appear
      expect(find.textContaining('Failed to export:'), findsOneWidget);
    });
  });
}
