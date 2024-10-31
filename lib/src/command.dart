// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'event_field.dart';
import 'integer_field.dart';
import 'string_field.dart';

/// A command is used to handle momentary requests by the user such that, when the command is issued,
/// the service does something useful.  It is often rendered as a button with clear boundaries that
/// suggest it can be clicked.
class Command extends PrimitiveBase {
  Command({super.embodiment, super.tag, String label = '', int status = 0}) {
    _commandIssued = EventField();
    _commandIssued.timeProvider = DateTime.now;
    _label = StringField.from(label);
    _status = IntegerField.from(status);
  }

  // Field storage
  late EventField _commandIssued;
  late StringField _label;
  late IntegerField _status;

  @override
  String get describeType => 'Command';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyCommandIssued, _commandIssued));
    fieldRefs.add(FieldRef(fkeyLabel, _label));
    fieldRefs.add(FieldRef(fkeyLabel, _status));
  }

  @override
  String toString() {
    return _label.value;
  }

  /// True if the command was issued during the current Wait cycle.
  bool get issued => _commandIssued.issued;

  /// Issues the command now.
  void issueNow() {
    _commandIssued.issueNow();
  }

  /// The label to display in the command.
  String get label => _label.value;
  set label(String label) {
    _label.value = label;
  }

  /// the status of the command:  0 = Command Normal, 1 = Command Disabled, 2 = Command Hidden.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }
}
