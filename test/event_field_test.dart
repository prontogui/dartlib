import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/event_field.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/fkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('EventField', () {
    late EventField field;
    late FieldHooksMock fieldhooks;

    prepareForUpdates() {
      field.prepareForUpdates(fkeyCommandIssued, PKey(0), 0, fieldhooks);
    }

    setUp(() {
      field = EventField();
      fieldhooks = FieldHooksMock();
      prepareForUpdates();
    });

    test('issued should return false if _eventTimestamp is null', () {
      expect(field.issued, isFalse);
    });

    test('issued returns true after calling issueNow()', () {
      prepareForUpdates();
      field.issueNow();
      expect(field.issued, isTrue);
      fieldhooks.verifyTotalCalls(1);
    });

    test(
        'issued should return false if _eventTimestamp does not match timeProvider',
        () {
      field.ingestFullCborValue(CborBool(true));
      fieldhooks.timestamp = fieldhooks.timestamp.add(Duration(seconds: 1));
      expect(field.issued, isFalse);
    });

    test('full update should return issued false', () {
      field.ingestFullCborValue(CborBool(true));
      expect(field.issued, isFalse);
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestPartialCborValue with true then issued returns true', () {
      field.ingestPartialCborValue(CborBool(true));
      expect(field.issued, isTrue);
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingestPartialCborValue with false then issued returns true', () {
      field.ingestPartialCborValue(CborBool(false));
      expect(field.issued, isTrue);
      fieldhooks.verifyTotalCalls(1);
    });

    test('egestCborValue should return CborBool(false)', () {
      expect(field.egestCborValue(), CborBool(false));
    });

    test('toString should return <Event Issued> if issued is true', () {
      field.issueNow();
      expect(field.toString(), '<Event Issued>');
    });

    test('toString should return <Event Not Issued> if issued is false', () {
      expect(field.toString(), '<Event Not Issued>');
    });
  });
}
