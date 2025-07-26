import 'package:fetosense_mis/utils/format_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDate', () {
    test('should format a valid ISO 8601 date string', () {
      // Arrange
      const isoDate = '2023-10-01T12:00:00Z';

      // Act
      final result = formatDate(isoDate);

      // Assert
      expect(result, '01/10/2023');
    });

    test('should return an empty string for null input', () {
      // Act
      final result = formatDate(null);

      // Assert
      expect(result, '');
    });

    test('should return an empty string for empty input', () {
      // Act
      final result = formatDate('');

      // Assert
      expect(result, '');
    });

    test('should return an empty string for invalid date format', () {
      // Arrange
      const invalidDate = 'invalid-date';

      // Act
      final result = formatDate(invalidDate);

      // Assert
      expect(result, '');
    });

    test('should handle ISO 8601 date without time component', () {
      // Arrange
      const isoDate = '2023-10-01';

      // Act
      final result = formatDate(isoDate);

      // Assert
      expect(result, '01/10/2023');
    });
  });
}