import 'dartiveAid.dart';

class Cache {
  static Map<String, dynamic> map = {};
  static int get size => map.toString().length;
  static Notifyer notifiyer = Notifyer();

  static void fromSource(Object? other) {
    try {
      if (other is String) map = Map.from(other.tryTo<Map>()!);
      if (other is Map) map = Map.from(other);
    } catch (e) {
      Log.e(Cache, "fromSource", e);
    }
  }

  static T get<T>(String key, T val) {
    return map[key] ?? val;
  }

  static void set(String key, val) {
    map[key] = val;
    notifiyer.pub();
  }

  static bool has<T>(String key, [Object? val]) => map.has(key, val);
  static void del(String key) {
    map.remove(key);
    notifiyer.pub();
  }

  static void clear() {
    map.clear();
    notifiyer.pub();
  }

  static void merge(String key, Map other) {
    if (map.has(key) && map[key] is Map) {
      Map older = map[key];
      older.mergeInto(other);
      map[key] = older;
    } else {
      map[key] = other;
    }
    notifiyer.pub();
  }
}
