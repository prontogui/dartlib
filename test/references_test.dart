// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/references.dart';
import 'package:dartlib/src/primitive_locator.dart';
import 'package:dartlib/src/nothing.dart';
import 'package:dartlib/src/primitive.dart';

class MockPrimitiveLocator implements PrimitiveLocator {
 MockPrimitiveLocator() : primitive = Nothing();

  Primitive primitive;
  late PKey pkey;

  @override
  Primitive? locatePrimitive(PKey pkey) {
    this.pkey = pkey;
    return primitive;
  }
}

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

  test('defineTarget maps refID to PKey', () {
    final pkey = PKey(1, 2, 3);
    refs.defineTarget('id1', pkey);
    var locator = MockPrimitiveLocator();
    var p = refs.dereference('id1', locator);
    expect(p, same(locator.primitive));
    expect(locator.pkey, equals(PKey(1, 2, 3)));
  });

  test('defineTarget followed by undefine maps refID to null', () {
    final pkey = PKey(1, 2, 3);
    var refNo = refs.defineTarget('id1', pkey);
    refs.undefineTarget(refNo);
    var locator = MockPrimitiveLocator();
    var p = refs.dereference('id1', locator);
    expect(p, isNull);
  });

  test('define several and undefine some', () {
    var refNo1 = refs.defineTarget('id1', PKey(1, 2, 3));
    refs.defineTarget('id2', PKey(2, 3, 4));
    refs.defineTarget('id3', PKey(2, 3, 5));
    refs.defineTarget('id4', PKey(1, 3, 1));
    refs.defineTarget('id5', PKey(1, 3, 2));
    var refNo6 = refs.defineTarget('id6', PKey(1, 5, 2));
    refs.undefineTarget(refNo1);
    refs.undefineTarget(refNo6);

    var locator = MockPrimitiveLocator();

    var p1 = refs.dereference('id1', locator);
    expect(p1, isNull);

    var p2 = refs.dereference('id2', locator);
    expect(p2, same(locator.primitive));
    expect(locator.pkey, equals(PKey(2, 3, 4)));

    var p3 = refs.dereference('id3', locator);
    expect(p3, same(locator.primitive));
    expect(locator.pkey, equals(PKey(2, 3, 5)));

    var p4 = refs.dereference('id4', locator);
    expect(p4, same(locator.primitive));
    expect(locator.pkey, equals(PKey(1, 3, 1)));

    var p5 = refs.dereference('id5', locator);
    expect(p5, same(locator.primitive));
    expect(locator.pkey, equals(PKey(1, 3, 2)));

    var p6 = refs.dereference('id6', locator);
    expect(p6, isNull);
  });

  test('define multiple targets same refID', () {
    refs.defineTarget('id1', PKey(1, 2, 3));
    refs.defineTarget('id1', PKey(2, 3, 4));
    refs.defineTarget('id1', PKey(2, 3, 5));
  
    var locator = MockPrimitiveLocator();

    var p = refs.dereference('id1', locator);
    expect(p, same(locator.primitive));
    expect(locator.pkey, equals(PKey(2, 3, 5)));
  });

  test('define multiple targets with same refID then reduce to just one', () {
    refs.defineTarget('id1', PKey(1, 2, 3));
    var refNo2 = refs.defineTarget('id1', PKey(2, 3, 4));
    var refNo3 = refs.defineTarget('id1', PKey(2, 3, 5));
  
    refs.undefineTarget(refNo2);
    refs.undefineTarget(refNo3);

    var locator = MockPrimitiveLocator();

    var p = refs.dereference('id1', locator);
    expect(p, same(locator.primitive));
    expect(locator.pkey, equals(PKey(1, 2, 3)));
  });

});
}