// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/references.dart';

void main() {
  group('References', () {
    late References refs;

    setUp(() {
      refs = References();
      // Clean up state for singleton between tests
      // Remove all defined targets and late refs
      refs.resetState();
    });

    test('Singleton returns the same instance', () {
      final refs2 = References();
      expect(refs, same(refs2));
    });

    test('defineTarget maps refID to PKey and calls late refs', () {
      final pkey = PKey();
      bool callbackCalled = false;
      final refNo = refs.reference('id1', (pk) {
        callbackCalled = true;
        expect(pk, same(pkey));
      });
      expect(refNo, isNonNegative);

      refs.defineTarget('id1', pkey);

      expect(callbackCalled, isTrue);
      expect(refs.refs['id1'], same(pkey));
      expect(refs.lateRefs.containsKey('id1'), isFalse);
    });

    test('defineTarget with no late refs just maps refID', () {
      final pkey = PKey();
      refs.defineTarget('id2', pkey);
      expect(refs.refs['id2'], same(pkey));
    });

    test('undefineTarget removes mapping', () {
      final pkey = PKey();
      refs.defineTarget('id3', pkey);
      expect(refs.refs.containsKey('id3'), isTrue);
      refs.undefineTarget('id3');
      expect(refs.refs.containsKey('id3'), isFalse);
    });

    test('undefineTarget asserts if late refs exist', () {
      refs.reference('id4', (_) {});
      expect(() => refs.undefineTarget('id4'), throwsA(isA<AssertionError>()));
    });

    test('reference returns invalidRefNo if already defined', () {
      final pkey = PKey();
      refs.defineTarget('id5', pkey);
      bool called = false;
      final refNo = refs.reference('id5', (pk) {
        called = true;
        expect(pk, same(pkey));
      });
      expect(refNo, References.invalidRefNo);
      expect(called, isTrue);
    });

    test('reference adds late reference and returns refNo', () {
      bool called = false;
      final refNo = refs.reference('id6', (_) {
        called = true;
      });
      expect(refNo, isNonNegative);
      expect(refs.lateRefs['id6']!.containsKey(refNo), isTrue);
      expect(called, isFalse);
    });

    test('dereference removes late reference', () {
      bool called = false;
      final refNo = refs.reference('id7', (_) {
        called = true;
      });
      expect(refs.lateRefs['id7']!.containsKey(refNo), isTrue);
      refs.dereference('id7', refNo);
      expect(refs.lateRefs['id7']!.containsKey(refNo), isFalse);
      expect(called, isFalse);
    });

    test('dereference with invalidRefNo does nothing', () {
      expect(() => refs.dereference('id8', References.invalidRefNo), returnsNormally);
    });

    test('reference rolls over and throws when max reached', () {
      refs.lastRefNo = refs.maxRefNo;
      expect(() => refs.reference('id9', (_) {}), throwsA(isA<StateError>()));
    });

    test('_checkToResetLastRef resets _lastRefNo when no late refs', () {
      refs.lastRefNo = 42;
      refs.lateRefs.clear();
      refs.checkToResetLastRef();
      expect(refs.lastRefNo, References.invalidRefNo);
    });
  });
}