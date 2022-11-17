part of 'dartiveAid.dart';

extension AlmExtensionMap on Map {
  int get size => isEmptyOrNull ? 0 : this.length;

  bool get isSuccess => has('status', 1) || has('code', 1) || has('result', 'success');

  T get<T>(key, T val) => this[key] ?? val;
  T? jet<T>(key) {
    if (has(key)) {
      Object o = this[key];
      return o.tryTo<T>();
    }
    return null;
  }

  T fet<T>(key, T val) {
    return jet(key) ?? val;
  }

  T result<T>(T val) => this['result'] ?? val;

  void keyTo(Object key, Object to) {
    this[to] = this[key];
    this.remove(key);
  }

  String keyTree() {
    var res = [];
    forEach((key, value) {
      if (value is Map) {
        res.add('$key->${value.keyTree()}');
      } else {
        res.add(key);
      }
    });
    return res.toString();
  }

  bool has<T>(Object key, [Object? val]) {
    if (isEmptyOrNull) return false;
    Map o = this;
    if (key is List) {
      for (var k in key) {
        if (!o.containsKey(k)) return false;
        if (!(o[k] is T)) return false;
      }
    } else {
      if (!o.containsKey(key)) return false;
      if (!(o[key] is T)) return false;
      if (val.isNotNull) return o[key] == val;
    }
    return true;
  }

  int get randomIndex => Random().nextInt(size);

  T randomKey<T>() => this.keys.elementAt(randomIndex);

  T randomVal<T>() => this.values.elementAt(randomIndex);

  Map<K, V> mergeInto<K, V>(Map? other, {List<K>? ignoreKeys}) {
    if (other is Map) {
      other.forEach((key, value) {
        if (ignoreKeys != null) {
          if (!ignoreKeys.has(key)) this[key] = value;
        } else {
          this[key] = value;
        }
      });
    }
    return Map<K, V>.from(this);
  }

  Map<K, V>? ignore<K, V>(List<K> ignoreKeys) {
    if (isEmptyOrNull) return null;
    var map = <K, V>{};
    forEach((key, value) {
      if (!ignoreKeys.has(key)) {
        map[key] = value;
      }
    });
    return map;
  }

  String toQuery({Encoding encoding = utf8}) {
    var pairs = <List<String>>[];
    forEach((key, value) => pairs.add([Uri.encodeQueryComponent(key.toString(), encoding: encoding), Uri.encodeQueryComponent(value.toString(), encoding: encoding)]));
    return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
  }
}
