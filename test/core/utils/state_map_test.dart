import 'package:fetosense_mis/core/utils/state_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('India States with Cities', () {
    test('should contain all states', () {
      expect(indiaStatesWithCities.keys, containsAll([
        'Andhra Pradesh',
        'Arunachal Pradesh',
        'Assam',
        'Bihar',
        'Chhattisgarh',
        'Goa',
        'Gujarat',
        'Haryana',
        'Himachal Pradesh',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Madhya Pradesh',
        'Maharashtra',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Odisha',
        'Punjab',
        'Rajasthan',
        'Sikkim',
        'Tamil Nadu',
        'Telangana',
        'Tripura',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal',
        'Andaman and Nicobar Islands',
        'Chandigarh',
        'Dadra and Nagar Haveli and Daman and Diu',
        'Delhi',
        'Jammu and Kashmir',
        'Ladakh',
        'Lakshadweep',
        'Puducherry',
      ]));
    });

    test('should contain correct cities for Andhra Pradesh', () {
      expect(indiaStatesWithCities['Andhra Pradesh'], containsAll([
        'Visakhapatnam',
        'Vijayawada',
        'Guntur',
        'Nellore',
        'Tirupati',
      ]));
    });

    test('should contain correct cities for Maharashtra', () {
      expect(indiaStatesWithCities['Maharashtra'], containsAll([
        'Mumbai',
        'Pune',
        'Nagpur',
        'Nashik',
        'Thane',
      ]));
    });

    test('should contain correct cities for Union Territories', () {
      expect(indiaStatesWithCities['Delhi'], containsAll([
        'New Delhi',
        'Dwarka',
        'Saket',
        'Rohini',
        'Karol Bagh',
      ]));
      expect(indiaStatesWithCities['Ladakh'], containsAll([
        'Leh',
        'Kargil',
      ]));
    });

    test('should not contain undefined states or cities', () {
      expect(indiaStatesWithCities.keys, isNot(contains('Undefined State')));
      expect(indiaStatesWithCities.values.expand((cities) => cities), isNot(contains('Undefined City')));
    });
  });
}