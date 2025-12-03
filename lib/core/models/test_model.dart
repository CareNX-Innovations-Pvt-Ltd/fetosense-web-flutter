import 'dart:convert';
import 'package:flutter/foundation.dart';

class Test {
  String? id;
  String? documentId;
  String? motherId;
  String? deviceId;
  String? doctorId;

  int? weight;
  int? gAge;
  int? fisherScore;
  int? fisherScore2;

  String? motherName;
  String? deviceName;
  String? doctorName;
  String? patientId;
  int? age;

  String? organizationId;
  String? organizationName;

  List<int>? bpmEntries;
  List<int>? bpmEntries2;
  List<int>? mhrEntries;
  List<int>? spo2Entries;
  List<int>? baseLineEntries;
  List<int>? movementEntries;
  List<int>? autoFetalMovement;
  List<int>? tocoEntries;

  int? lengthOfTest;
  int? averageFHR;

  bool? live;
  bool? testByMother;
  String? testById;
  String? interpretationType;
  String? interpretationExtraComments;

  dynamic associations;
  dynamic autoInterpretations;

  bool? delete;
  DateTime? createdOn;
  String? createdBy;
  bool? referral;

  Test({
    this.id,
    this.documentId,
    this.motherId,
    this.deviceId,
    this.doctorId,
    this.weight,
    this.gAge,
    this.fisherScore,
    this.fisherScore2,
    this.motherName,
    this.deviceName,
    this.doctorName,
    this.patientId,
    this.age,
    this.organizationId,
    this.organizationName,
    this.bpmEntries,
    this.bpmEntries2,
    this.mhrEntries,
    this.spo2Entries,
    this.baseLineEntries,
    this.movementEntries,
    this.autoFetalMovement,
    this.tocoEntries,
    this.lengthOfTest,
    this.averageFHR,
    this.live,
    this.testByMother,
    this.testById,
    this.interpretationType,
    this.interpretationExtraComments,
    this.associations,
    this.autoInterpretations,
    this.delete,
    this.createdOn,
    this.createdBy,
    this.referral,
  });

  /// From Map (null safe)
  Test.fromMap(Map snapshot, String id) {
    this.id = snapshot['id'] ?? id;
    documentId = snapshot['documentId'];
    motherId = snapshot['motherId'];
    deviceId = snapshot['deviceId'];
    doctorId = snapshot['doctorId'];

    weight = snapshot['weight'];
    gAge = snapshot['gAge'];
    age = snapshot['age'];
    fisherScore = snapshot['fisherScore'];
    fisherScore2 = snapshot['fisherScore2'];

    motherName = snapshot['motherName'];
    deviceName = snapshot['deviceName'];
    doctorName = snapshot['doctorName'];
    patientId = snapshot['patientId'];

    organizationId = snapshot['organizationId'];
    organizationName = snapshot['organizationName'];

    bpmEntries = _safeList(snapshot['bpmEntries']);
    bpmEntries2 = _safeList(snapshot['bpmEntries2']);
    mhrEntries = _safeList(snapshot['mhrEntries']);
    spo2Entries = _safeList(snapshot['spo2Entries']);
    baseLineEntries = _safeList(snapshot['baseLineEntries']);
    movementEntries = _safeList(snapshot['movementEntries']);
    autoFetalMovement = _safeList(snapshot['autoFetalMovement']);
    tocoEntries = _safeList(snapshot['tocoEntries']);

    lengthOfTest = snapshot['lengthOfTest'];
    averageFHR = snapshot['averageFHR'];

    live = snapshot['live'];
    testByMother = snapshot['testByMother'];
    testById = snapshot['testById'];
    interpretationType = snapshot['interpretationType'];
    interpretationExtraComments = snapshot['interpretationExtraComments'];

    // JSON decode safely
    associations = _decode(snapshot['association']);
    autoInterpretations = _decode(snapshot['autoInterpretations']);

    delete = snapshot['delete'];
    createdOn = _parseDate(snapshot['createdOn']);
    createdBy = snapshot['createdBy'];
    referral = snapshot['referral'];
  }

  /// Convert to Map (null safe)
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'motherId': motherId,
      'deviceId': deviceId,
      'doctorId': doctorId,
      'weight': weight,
      'gAge': gAge,
      'fisherScore': fisherScore,
      'fisherScore2': fisherScore2,
      'motherName': motherName,
      'deviceName': deviceName,
      'doctorName': doctorName,
      'patientId': patientId,
      'age': age,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'bpmEntries': bpmEntries ?? [],
      'bpmEntries2': bpmEntries2 ?? [],
      'mhrEntries': mhrEntries ?? [],
      'spo2Entries': spo2Entries ?? [],
      'baseLineEntries': baseLineEntries ?? [],
      'movementEntries': movementEntries ?? [],
      'autoFetalMovement': autoFetalMovement ?? [],
      'tocoEntries': tocoEntries ?? [],
      'lengthOfTest': lengthOfTest,
      'averageFHR': averageFHR,
      'live': live,
      'testByMother': testByMother,
      'testById': testById,
      'interpretationType': interpretationType,
      'interpretationExtraComments': interpretationExtraComments,
      'association': associations != null ? jsonEncode(associations) : null,
      'autoInterpretations':
          autoInterpretations != null ? jsonEncode(autoInterpretations) : null,
      'delete': delete,
      'createdOn': createdOn?.toIso8601String(),
      'createdBy': createdBy,
      'referral': referral,
    };
  }

  /// Debug print
  void printDetails() {
    if (!kDebugMode) return;
    print(jsonEncode(toJson()));
  }
}

/// Helper to handle null lists
List<int>? _safeList(dynamic raw) {
  if (raw == null) return <int>[];
  if (raw is List) return raw.cast<int>();
  return <int>[];
}

/// Helper to safely decode JSON
dynamic _decode(dynamic raw) {
  if (raw == null) return null;
  if (raw is String) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
  return raw;
}

DateTime _parseDate(dynamic raw) {
  if (raw == null) return DateTime(1900);

  if (raw is String && raw.isNotEmpty) {
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return DateTime(1900);
    }
  }

  if (raw is int) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    } catch (_) {
      return DateTime(1900);
    }
  }

  if (raw is Map && raw.containsKey("\$date")) {
    try {
      return DateTime.parse(raw["\$date"]);
    } catch (_) {
      return DateTime(1900);
    }
  }

  return DateTime(1900);
}
