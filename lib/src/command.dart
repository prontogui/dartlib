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
    fieldRefs.add(FieldRef(fkeyStatus, _status));
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

  /// The status of the command:  0 = Command Normal, 1 = Command Disabled, 2 = Command Hidden.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  /// The enabled status of the command.  This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)
  /// and setting this to false will set Status to 1 (disabled).
  ///
  /// Note:  this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  /// Tthe visibility of the command.  This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)and setting
  /// this to false will set Status to 2 (hidden).
  ///
  /// Note:  this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get visible => status != 2;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }
}
