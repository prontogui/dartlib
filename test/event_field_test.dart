import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/event_field.dart';
import 'package:dartlib/src/field_hooks.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/fkey.dart';

class EventFieldSetup extends FieldHooks {
  EventFieldSetup() {
    eventField = EventField();
    eventField.prepareForUpdates(fkeyCommandIssued, PKey(0), 0, this);
    testTime = DateTime.now();
  }

  late EventField eventField;
  late DateTime testTime;

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    // Do nothing.
  }

  @override
  DateTime getEventTimestamp() {
    return testTime;
  }
}

void main() {
  group('EventField', () {
    late EventFieldSetup t;

    setUp(() {
      t = EventFieldSetup();
    });

    test('issued should return false if _eventTimestamp is null', () {
      expect(t.eventField.issued, isFalse);
    });

    test('issued should return true if _eventTimestamp matches timeProvider',
        () {
      t.eventField.ingestFullCborValue(CborBool(true));
      expect(t.eventField.issued, isTrue);
    });

    test(
        'issued should return false if _eventTimestamp does not match timeProvider',
        () {
      t.eventField.ingestFullCborValue(CborBool(true));
      t.testTime = t.testTime.add(Duration(seconds: 1));
      expect(t.eventField.issued, isFalse);
    });

    test('ingestFullCborValue should set _eventTimestamp', () {
      t.eventField.ingestFullCborValue(CborBool(true));
      expect(t.eventField.issued, isTrue);
    });

    test('ingestPartialCborValue should set _eventTimestamp', () {
      t.eventField.ingestPartialCborValue(CborBool(true));
      expect(t.eventField.issued, isTrue);
    });

    test('egestCborValue should return CborBool(false)', () {
      expect(t.eventField.egestCborValue(), CborBool(false));
    });

    test('toString should return <Event Issued> if issued is true', () {
      t.eventField.ingestFullCborValue(CborBool(true));
      expect(t.eventField.toString(), '<Event Issued>');
    });

    test('toString should return <Event Not Issued> if issued is false', () {
      expect(t.eventField.toString(), '<Event Not Issued>');
    });

    test('should throw exception if timeProvider is not set', () {
      t.eventField = EventField();
      expect(() => t.eventField.ingestFullCborValue(CborBool(true)),
          throwsException);
    });
  });
}
