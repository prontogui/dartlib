typedef FKey = int;

const invalidFieldName = -1;
const invalidFKey = "";

final fkeyToFieldnameMap = {
  // 0 is reserved.  Don't use!
  1: "B.Row",
  2: "B.Col",
  3: "B.Embodiment",
  4: "Label",
  5: "Issued",
  6: "Status",
  7: "Choices",
  8: "Data",
  9: "ListItems",
  10: "Rows"
};

final List<String> _fkeyToFieldname = _lazyLoading1();
final Map<String, int> _fieldnameToFKey = _lazyLoading2();

List<String> _lazyLoading1() {
  var numFKeys = fkeyToFieldnameMap.length + 1;
  var fkeyToFieldname = List<String>.filled(numFKeys, "", growable: false);

  fkeyToFieldnameMap.forEach((key, value) {
    fkeyToFieldname[key] = value;
  });

  return fkeyToFieldname;
}

Map<String, int> _lazyLoading2() {
  Map<String, int> fieldnameToFKey = {};

  fkeyToFieldnameMap.forEach((key, value) {
    fieldnameToFKey[value] = key;
  });

  return fieldnameToFKey;
}

FKey fkeyFor(String fieldname) {
  return _fieldnameToFKey[fieldname]!;
}

String fieldnameFor(FKey fkey) {
  return _fkeyToFieldname[fkey];
}
