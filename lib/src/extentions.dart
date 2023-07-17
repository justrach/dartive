part of 'dartiveAid.dart';

extension ExtensionObject on Object? {
  bool get isNull => this == null;
  String get TAG => this == null ? 'null' : this!.runtimeType.toString();

  bool get isNotNull => !isNull;
  bool get isNotEmptyOrNull => !isEmptyOrNull;
  bool get isEmptyOrNull {
    Object? s = this;
    if (s.isNull) return true;
    if (s is List) return s.isEmpty;
    if (s is Map) return s.isEmpty;
    if (s is String) return s.isEmpty;
    return false;
  }

  bool get isString => this is String;
  bool get isList => this is List;
  bool get isMap => this is Map;
  bool get isInt => this is int;
  bool get isNumber => this is num;
  bool get isDouble => this is double;

  T? tryTo<T>() {
    if (isNull) return null;
    try {
      String o = this!.enJson();
      return jsonDecode(o);
    } catch (e) {
      print(e);
    }
    return null;
  }
}

extension ExtensionObjectN on Object {
  String enJson() {
    Object o = this;
    if (o is String) return o;
    return jsonEncode(this, toEncodable: (o) => o.toString());
  }
}
