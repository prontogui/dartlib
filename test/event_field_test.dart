import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/event_field.dart';

void main() {
  group('EventField', () {
    late EventField eventField;
    late DateTime testTime;

    setUp(() {
      eventField = EventField();
      testTime = DateTime.now();
      eventField.timeProvider = () => testTime;
    });

    test('issued should return false if _eventTimestamp is null', () {
      expect(eventField.issued, isFalse);
    });

    test('issued should return true if _eventTimestamp matches timeProvider',
        () {
      eventField.ingestFullCborValue(CborBool(true));
      expect(eventField.issued, isTrue);
    });

    test(
        'issued should return false if _eventTimestamp does not match timeProvider',
        () {
      eventField.ingestFullCborValue(CborBool(true));
      testTime = testTime.add(Duration(seconds: 1));
      expect(eventField.issued, isFalse);
    });

    test('ingestFullCborValue should set _eventTimestamp', () {
      eventField.ingestFullCborValue(CborBool(true));
      expect(eventField.issued, isTrue);
    });

    test('ingestPartialCborValue should set _eventTimestamp', () {
      eventField.ingestPartialCborValue(CborBool(true));
      expect(eventField.issued, isTrue);
    });

    test('egestCborValue should return CborBool(false)', () {
      expect(eventField.egestCborValue(), CborBool(false));
    });

    test('toString should return <Event Issued> if issued is true', () {
      eventField.ingestFullCborValue(CborBool(true));
      expect(eventField.toString(), '<Event Issued>');
    });

    test('toString should return <Event Not Issued> if issued is false', () {
      expect(eventField.toString(), '<Event Not Issued>');
    });

    test('should throw exception if timeProvider is not set', () {
      eventField = EventField();
      expect(() => eventField.ingestFullCborValue(CborBool(true)),
          throwsException);
    });
  });
}
