class Obj {
  Obj();

  factory Obj.fromJson(Map json) {
    final obj1 = json['obj1'];
    final aa = json['aa'];
    final bb = json['bb'];
    final cc = json['cc'];
    final complex = json['complex'];
    final array4 = json['array4'];
    final array5 = json['array5'];
    final array6 = json['array6'];
    return Obj()
      ..a = json['a']
      ..b = json['b']
      ..c = json['c']
      ..d = json['d']
      ..obj1 = ObjObj1.fromJson(
        obj1 as Map<String, dynamic>,
      )
      ..aa = aa.map<ObjAaItem>((e) {
        return ObjAaItem.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..bb = bb.map<ObjBbItem>((e) {
        return ObjBbItem.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..cc = cc.map<ObjCcItem>((e) {
        return ObjCcItem.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..complex = complex.map((e) {
        return e is Map
            ? ObjComplexItem.fromJson(
                e as Map<String, dynamic>,
              )
            : e is List
                ? e.map((e) {
                    return ObjComplexItemItem.fromJson(
                      e as Map<String, dynamic>,
                    );
                  }).toList()
                : throw ArgumentError('Unknown value: $e');
      }).toList()
      ..array = json['array']
      ..array1 = json['array1']
      ..array2 = json['array2']
      ..array3 = json['array3']
      ..array4 = array4.map<ObjArray4Item>((e) {
        return ObjArray4Item.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..array5 = array5.map<ObjArray5Item>((e) {
        return ObjArray5Item.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..array6 = array6.map<List<List<ObjArray6ItemItemItem>>>((e) {
        return e.map<List<ObjArray6ItemItemItem>>((e) {
          return e.map<ObjArray6ItemItemItem>((e) {
            return ObjArray6ItemItemItem.fromJson(
              e as Map<String, dynamic>,
            );
          }).toList();
        }).toList();
      }).toList();
  }

  late String a;
  late bool b;
  late int c;
  dynamic d;
  late ObjObj1 obj1;
  late List<ObjAaItem> aa;
  late List<ObjBbItem> bb;
  late List<ObjCcItem> cc;
  late List<dynamic> complex;
  late List<String> array;
  late List<dynamic> array1;
  late List<String?> array2;
  late List<dynamic> array3;
  late List<ObjArray4Item> array4;
  late List<ObjArray5Item> array5;
  late List<List<List<ObjArray6ItemItemItem>>> array6;

  Map<String, dynamic> toJson() {
    return {
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'obj1': obj1,
      'aa': aa,
      'bb': bb,
      'cc': cc,
      'complex': complex,
      'array': array,
      'array1': array1,
      'array2': array2,
      'array3': array3,
      'array4': array4,
      'array5': array5,
      'array6': array6,
    };
  }
}

class ObjObj1 {
  ObjObj1();

  factory ObjObj1.fromJson(Map json) {
    return ObjObj1()
      ..o1 = json['o1']
      ..o2 = json['o2'];
  }

  late String o1;
  late String o2;

  Map<String, dynamic> toJson() {
    return {
      'o1': o1,
      'o2': o2,
    };
  }
}

class ObjAaItem {
  ObjAaItem();

  factory ObjAaItem.fromJson(Map json) {
    return ObjAaItem()
      ..o1 = json['o1']
      ..o2 = json['o2'];
  }

  String? o1;
  dynamic o2;

  Map<String, dynamic> toJson() {
    return {
      'o1': o1,
      'o2': o2,
    };
  }
}

class ObjBbItem {
  ObjBbItem();

  factory ObjBbItem.fromJson(Map json) {
    return ObjBbItem()
      ..o1 = json['o1']
      ..o2 = json['o2']
      ..o3 = json['o3'];
  }

  late String o1;
  String? o2;
  String? o3;

  Map<String, dynamic> toJson() {
    return {
      'o1': o1,
      'o2': o2,
      'o3': o3,
    };
  }
}

class ObjCcItem {
  ObjCcItem();

  factory ObjCcItem.fromJson(Map json) {
    final v = json['v'];
    return ObjCcItem()
      ..o1 = json['o1']
      ..v = v is Map
          ? ObjCcItemObjV.fromJson(
              v as Map<String, dynamic>,
            )
          : v is List
              ? v.map((e) {
                  return ObjCcItemObjVItem.fromJson(
                    e as Map<String, dynamic>,
                  );
                }).toList()
              : v;
  }

  late String o1;
  dynamic v;

  Map<String, dynamic> toJson() {
    return {
      'o1': o1,
      'v': v,
    };
  }
}

class ObjCcItemObjVItem {
  ObjCcItemObjVItem();

  factory ObjCcItemObjVItem.fromJson(Map json) {
    return ObjCcItemObjVItem()..abc = json['abc'];
  }

  late int abc;

  Map<String, dynamic> toJson() {
    return {
      'abc': abc,
    };
  }
}

class ObjCcItemObjV {
  ObjCcItemObjV();

  factory ObjCcItemObjV.fromJson(Map json) {
    return ObjCcItemObjV()..hehe = json['hehe'];
  }

  late bool hehe;

  Map<String, dynamic> toJson() {
    return {
      'hehe': hehe,
    };
  }
}

class ObjComplexItem {
  ObjComplexItem();

  factory ObjComplexItem.fromJson(Map json) {
    return ObjComplexItem()
      ..a = json['a']
      ..b = json['b']
      ..c = json['c']
      ..d = json['d'];
  }

  dynamic a;
  dynamic b;
  String? c;
  String? d;

  Map<String, dynamic> toJson() {
    return {
      'a': a,
      'b': b,
      'c': c,
      'd': d,
    };
  }
}

class ObjComplexItemItem {
  ObjComplexItemItem();

  factory ObjComplexItemItem.fromJson(Map json) {
    return ObjComplexItemItem()..d = json['d'];
  }

  late String d;

  Map<String, dynamic> toJson() {
    return {
      'd': d,
    };
  }
}

class ObjArray4Item {
  ObjArray4Item();

  factory ObjArray4Item.fromJson(Map json) {
    return ObjArray4Item()
      ..k1 = json['k1']
      ..k2 = json['k2'];
  }

  late String k1;
  String? k2;

  Map<String, dynamic> toJson() {
    return {
      'k1': k1,
      'k2': k2,
    };
  }
}

class ObjArray5Item {
  ObjArray5Item();

  factory ObjArray5Item.fromJson(Map json) {
    final k3 = json['k3'];
    return ObjArray5Item()
      ..k1 = json['k1']
      ..k2 = json['k2']
      ..k3 = ObjArray5ItemObjK3.fromJson(
        k3 as Map<String, dynamic>,
      );
  }

  late String k1;
  String? k2;
  late ObjArray5ItemObjK3 k3;

  Map<String, dynamic> toJson() {
    return {
      'k1': k1,
      'k2': k2,
      'k3': k3,
    };
  }
}

class ObjArray5ItemObjK3 {
  ObjArray5ItemObjK3();

  factory ObjArray5ItemObjK3.fromJson(Map json) {
    return ObjArray5ItemObjK3()..v2 = json['v2'];
  }

  late String v2;

  Map<String, dynamic> toJson() {
    return {
      'v2': v2,
    };
  }
}

class ObjArray6ItemItemItem {
  ObjArray6ItemItemItem();

  factory ObjArray6ItemItemItem.fromJson(Map json) {
    final k3 = json['k3'];
    return ObjArray6ItemItemItem()
      ..k1 = json['k1']
      ..k2 = json['k2']
      ..k3 = k3 is List
          ? k3.map<List<ObjArray6ItemItemItemObjK3ItemItem>>((e) {
              return e.map<ObjArray6ItemItemItemObjK3ItemItem>((e) {
                return ObjArray6ItemItemItemObjK3ItemItem.fromJson(
                  e as Map<String, dynamic>,
                );
              }).toList();
            }).toList()
          : null;
  }

  late String k1;
  String? k2;
  List<List<ObjArray6ItemItemItemObjK3ItemItem>>? k3;

  Map<String, dynamic> toJson() {
    return {
      'k1': k1,
      'k2': k2,
      'k3': k3,
    };
  }
}

class ObjArray6ItemItemItemObjK3ItemItem {
  ObjArray6ItemItemItemObjK3ItemItem();

  factory ObjArray6ItemItemItemObjK3ItemItem.fromJson(Map json) {
    return ObjArray6ItemItemItemObjK3ItemItem()
      ..k21 = json['k21']
      ..k22 = json['k22'];
  }

  late String k21;
  String? k22;

  Map<String, dynamic> toJson() {
    return {
      'k21': k21,
      'k22': k22,
    };
  }
}
