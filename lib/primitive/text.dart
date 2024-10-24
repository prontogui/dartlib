// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/key/pkey.dart';
import 'package:dartlib/key/fkey.dart';
import 'package:dartlib/key/onset.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'string_field.dart';

class Text with PrimitiveBase implements Primitive {
  Text({String content = '', String embodiment = '', String tag = ''}) {
    _content = StringField.from(content);
    _embodiment = StringField.from(embodiment);
    _tag = StringField.from(tag);
  }

  late StringField _content;
  late StringField _embodiment;
  late StringField _tag;

  @override
  prepareForUpdates(PKey pkey, OnsetFunction onset) {
    internalPrepareForUpdates(pkey, onset, () {
      return [
        FieldRef(fkeyContent, _content),
        FieldRef(fkeyEmbodiment, _embodiment),
        FieldRef(fkeyTag, _tag),
      ];
    });
  }

  @override
  String toString() {
    return _content.get();
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    throw UnimplementedError();
  }

  // The text content to display.
  String get content => _content.get();
  set content(String content) {
    _content.set(content);
  }

  // The embodiment to use for rendering the Text.
  String get embodiment => _embodiment.get();
  set embodiment(String embodiment) {
    _embodiment.set(embodiment);
  }

  // The tag to keep around with this primitive.
  String get tag => _tag.get();
  set tag(String tag) {
    _tag.set(tag);
  }
}
