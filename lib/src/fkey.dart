// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
typedef FKey = int;

const invalidFieldName = -1;
const invalidFKey = '';

// ADD NEW FIELDS TO THIS BLOCK - ALPHABETICAL ORDER PLEASE!
const int fkeyChecked = 0;
const int fkeyChoice = 1;
const int fkeyChoices = 2;
const int fkeyCommandIssued = 3;
const int fkeyContent = 4;
const int fkeyData = 5;
const int fkeyDisplayFormat = 6;
const int fkeyEmbodiment = 7;
const int fkeyEntryFormat = 8;
const int fkeyExported = 9;
const int fkeyFrameItems = 10;
const int fkeyGroupItems = 11;
const int fkeyHeadings = 12;
const int fkeyImage = 13;
const int fkeyImported = 14;
const int fkeyIssued = 15;
const int fkeyLabel = 16;
const int fkeyListItems = 17;
const int fkeyName = 18;
const int fkeyNumericEntry = 19;
const int fkeyPeriodMs = 20;
const int fkeyRows = 21;
const int fkeySelected = 22;
const int fkeyShowing = 23;
const int fkeyState = 24;
const int fkeyStatus = 25;
const int fkeyTag = 26;
const int fkeyTextEntry = 27;
const int fkeyTimerFired = 28;
const int fkeyValidExtensions = 29;
const int fkeyMaximumKeys = 30;

final _fkeyToName = _initializeFkeyToName();
final _nameToFKey = _initializeNameToFKey();

List<String> _initializeFkeyToName() {
  var list = List<String>.filled(fkeyMaximumKeys, '', growable: false);

  // ADD NEW FIELDS TO THIS BLOCK - ALPHABETICAL ORDER PLEASE!
  list[fkeyChecked] = 'Checked';
  list[fkeyChoice] = 'Choice';
  list[fkeyChoices] = 'Choices';
  list[fkeyCommandIssued] = 'CommandIssued';
  list[fkeyContent] = 'Content';
  list[fkeyData] = 'Data';
  list[fkeyDisplayFormat] = 'DisplayFormat';
  list[fkeyEmbodiment] = 'Embodiment';
  list[fkeyEntryFormat] = 'EntryFormat';
  list[fkeyExported] = 'Exported';
  list[fkeyFrameItems] = 'FrameItems';
  list[fkeyGroupItems] = 'GroupItems';
  list[fkeyHeadings] = 'Headings';
  list[fkeyImage] = 'Image';
  list[fkeyImported] = 'Imported';
  list[fkeyIssued] = 'Issued';
  list[fkeyLabel] = 'Label';
  list[fkeyListItems] = 'ListItems';
  list[fkeyName] = 'Name';
  list[fkeyNumericEntry] = 'NumericEntry';
  list[fkeyPeriodMs] = 'PeriodMs';
  list[fkeyRows] = 'Rows';
  list[fkeySelected] = 'Selected';
  list[fkeyShowing] = 'Showing';
  list[fkeyState] = 'State';
  list[fkeyStatus] = 'Status';
  list[fkeyTag] = 'Tag';
  list[fkeyTextEntry] = 'TextEntry';
  list[fkeyTimerFired] = 'TimerFired';
  list[fkeyValidExtensions] = 'ValidExtensions';

  return list;
}

Map<String, int> _initializeNameToFKey() {
  return <String, int>{
    // ADD NEW FIELDS TO THIS BLOCK - ALPHABETICAL ORDER PLEASE!
    'Checked': fkeyChecked,
    'Choice': fkeyChoice,
    'Choices': fkeyChoices,
    'CommandIssued': fkeyCommandIssued,
    'Content': fkeyContent,
    'Data': fkeyData,
    'DisplayFormat': fkeyDisplayFormat,
    'Embodiment': fkeyEmbodiment,
    'EntryFormat': fkeyEntryFormat,
    'Exported': fkeyExported,
    'FrameItems': fkeyFrameItems,
    'GroupItems': fkeyGroupItems,
    'Headings': fkeyHeadings,
    'Image': fkeyImage,
    'Imported': fkeyImported,
    'Issued': fkeyIssued,
    'Label': fkeyLabel,
    'ListItems': fkeyListItems,
    'Name': fkeyName,
    'NumericEntry': fkeyNumericEntry,
    'PeriodMs': fkeyPeriodMs,
    'Rows': fkeyRows,
    'Selected': fkeySelected,
    'Showing': fkeyShowing,
    'State': fkeyState,
    'Status': fkeyStatus,
    'Tag': fkeyTag,
    'TextEntry': fkeyTextEntry,
    'TimerFired': fkeyTimerFired,
    'ValidExtensions': fkeyValidExtensions,
  };
}

FKey fkeyFor(String fieldname) {
  var found = _nameToFKey[fieldname];
  if (found == null) {
    return invalidFieldName;
  }
  return found;
}

String fieldnameFor(FKey fkey) {
  if (fkey >= fkeyMaximumKeys) {
    return invalidFKey;
  }
  return _fkeyToName[fkey];
}
