// Copyright 2025 ProntoGUI, LLC.
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
const int fkeyID = 14;
const int fkeyImage = 15;
const int fkeyImported = 16;
const int fkeyIssued = 17;
const int fkeyLabel = 18;
const int fkeyLeadingItem = 19;
const int fkeyListItems = 20;
const int fkeyMainItem = 21;
const int fkeyModelItem = 22;
const int fkeyModelRow = 23;
const int fkeyName = 24;
const int fkeyNodeItem = 25;
const int fkeyNumericEntry = 26;
const int fkeyPeriodMs = 27;
const int fkeyRef = 28;
const int fkeyRoot = 29;
const int fkeyRows = 30;
const int fkeySelectedIndex = 31;
const int fkeySelectedPath = 32;
const int fkeyShowing = 33;
const int fkeyState = 34;
const int fkeyStatus = 35;
const int fkeySubItem = 36;
const int fkeySubNodes = 37;
const int fkeyTag = 38;
const int fkeyTextEntry = 39;
const int fkeyTimerFired = 40;
const int fkeyTitle = 41;
const int fkeyTrailingItem = 42;
const int fkeyValidExtensions = 43;
const int fkeyMaximumKeys = 44;

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
  list[fkeyIconID] = 'IconID';
  list[fkeyID] = 'ID';
  list[fkeyImage] = 'Image';
  list[fkeyImported] = 'Imported';
  list[fkeyIssued] = 'Issued';
  list[fkeyLabel] = 'Label';
  list[fkeyLeadingItem] = 'LeadingItem';
  list[fkeyListItems] = 'ListItems';
  list[fkeyMainItem] = 'MainItem';
  list[fkeyModelItem] = 'ModelItem';
  list[fkeyModelRow] = 'ModelRow';
  list[fkeyName] = 'Name';
  list[fkeyNodeItem] = 'NodeItem';
  list[fkeyNumericEntry] = 'NumericEntry';
  list[fkeyPeriodMs] = 'PeriodMs';
  list[fkeyRef] = 'Ref';
  list[fkeyRoot] = 'Root';
  list[fkeyRows] = 'Rows';
  list[fkeySelectedIndex] = 'SelectedIndex';
  list[fkeySelectedPath] = 'SelectedPath';
  list[fkeyShowing] = 'Showing';
  list[fkeyState] = 'State';
  list[fkeyStatus] = 'Status';
  list[fkeySubItem] = 'SubItem';
  list[fkeySubNodes] = 'SubNodes';
  list[fkeyTag] = 'Tag';
  list[fkeyTextEntry] = 'TextEntry';
  list[fkeyTimerFired] = 'TimerFired';
  list[fkeyTitle] = 'Title';
  list[fkeyTrailingItem] = 'TrailingItem';
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
    'ID': fkeyID,
    'Image': fkeyImage,
    'Imported': fkeyImported,
    'Issued': fkeyIssued,
    'Label': fkeyLabel,
    'LeadingItem': fkeyLeadingItem,
    'ListItems': fkeyListItems,
    'MainItem': fkeyMainItem,
    'ModelItem': fkeyModelItem,
    'ModelRow': fkeyModelRow,
    'Name': fkeyName,
    'NodeItem': fkeyNodeItem,
    'NumericEntry': fkeyNumericEntry,
    'PeriodMs': fkeyPeriodMs,
    'Ref': fkeyRef,
    'Root': fkeyRoot,
    'Rows': fkeyRows,
    'SelectedIndex': fkeySelectedIndex,
    'SelectedPath': fkeySelectedPath,
    'Showing': fkeyShowing,
    'State': fkeyState,
    'Status': fkeyStatus,
    'SubItem': fkeySubItem,
    'SubNodes': fkeySubNodes,
    'Tag': fkeyTag,
    'TextEntry': fkeyTextEntry,
    'TimerFired': fkeyTimerFired,
    'Title': fkeyTitle,
    'TrailingItem': fkeyTrailingItem,
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
