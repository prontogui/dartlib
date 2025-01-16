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
const int fkeyChoiceLabels = 3;
const int fkeyCommandIssued = 4;
const int fkeyContent = 5;
const int fkeyData = 6;
const int fkeyEmbodiment = 7;
const int fkeyExported = 8;
const int fkeyFrameItems = 9;
const int fkeyGroupItems = 10;
const int fkeyHeadings = 11;
const int fkeyIcon = 12;
const int fkeyIconID = 13;
const int fkeyImage = 14;
const int fkeyImported = 15;
const int fkeyIssued = 16;
const int fkeyLabel = 17;
const int fkeyListItems = 18;
const int fkeyName = 19;
const int fkeyNumericEntry = 20;
const int fkeyPeriodMs = 21;
const int fkeyRows = 22;
const int fkeySelected = 23;
const int fkeyShowing = 24;
const int fkeyState = 25;
const int fkeyStatus = 26;
const int fkeySubEmbodiments = 27;
const int fkeyTag = 28;
const int fkeyTextEntry = 29;
const int fkeyTimerFired = 30;
const int fkeyTitle = 31;
const int fkeyValidExtensions = 32;
const int fkeyMaximumKeys = 33;

final _fkeyToName = _initializeFkeyToName();
final _nameToFKey = _initializeNameToFKey();

List<String> _initializeFkeyToName() {
  var list = List<String>.filled(fkeyMaximumKeys, '', growable: false);

  // ADD NEW FIELDS TO THIS BLOCK - ALPHABETICAL ORDER PLEASE!
  list[fkeyChecked] = 'Checked';
  list[fkeyChoice] = 'Choice';
  list[fkeyChoices] = 'Choices';
  list[fkeyChoiceLabels] = 'ChoiceLabels';
  list[fkeyCommandIssued] = 'CommandIssued';
  list[fkeyContent] = 'Content';
  list[fkeyData] = 'Data';
  list[fkeyEmbodiment] = 'Embodiment';
  list[fkeyExported] = 'Exported';
  list[fkeyFrameItems] = 'FrameItems';
  list[fkeyGroupItems] = 'GroupItems';
  list[fkeyHeadings] = 'Headings';
  list[fkeyIcon] = 'Icon';
  list[fkeyIcon] = 'IconID';
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
  list[fkeySubEmbodiments] = 'SubEmbodiments';
  list[fkeyTag] = 'Tag';
  list[fkeyTextEntry] = 'TextEntry';
  list[fkeyTimerFired] = 'TimerFired';
  list[fkeyTitle] = 'Title';
  list[fkeyValidExtensions] = 'ValidExtensions';

  return list;
}

Map<String, int> _initializeNameToFKey() {
  return <String, int>{
    // ADD NEW FIELDS TO THIS BLOCK - ALPHABETICAL ORDER PLEASE!
    'Checked': fkeyChecked,
    'Choice': fkeyChoice,
    'Choices': fkeyChoices,
    'ChoiceLabels': fkeyChoiceLabels,
    'CommandIssued': fkeyCommandIssued,
    'Content': fkeyContent,
    'Data': fkeyData,
    'Embodiment': fkeyEmbodiment,
    'Exported': fkeyExported,
    'FrameItems': fkeyFrameItems,
    'GroupItems': fkeyGroupItems,
    'Headings': fkeyHeadings,
    'Icon': fkeyIcon,
    'IconID': fkeyIconID,
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
    'SubEmbodiments': fkeySubEmbodiments,
    'Tag': fkeyTag,
    'TextEntry': fkeyTextEntry,
    'TimerFired': fkeyTimerFired,
    'Title': fkeyTitle,
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
