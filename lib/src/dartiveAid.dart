
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

export 'log.dart';
export 'sio.dart';
export 'cache.dart';
export 'dao.dart';

part 'extentions.dart';

part 'extentions_str.dart';

part 'extentions_num.dart';

part 'extentions_time.dart';

part 'extentions_list.dart';

part 'extentions_map.dart';

part 'extentions_file.dart';

typedef VCallbackT = dynamic Function();
typedef VCallbackT0<T> = dynamic Function([T]);
typedef VCallbackT1<T> = dynamic Function(T);
typedef VCallbackT2<T, Y> = dynamic Function(T, Y);
typedef VCallbackT3<T, Y, R> = dynamic Function(T, Y, R);

class DartiveAids {
  static String version = '1.0.0';

  static bool isWeb = identical(0, 0.0);

  static bool isLocalUtc = false;

  static Duration get duration {
    var t = timedate();
    return Duration(hours: t.hour, minutes: t.minute, seconds: t.second, milliseconds: t.millisecond, microseconds: t.microsecond);
  }

  static int get time => timedate().millisecondsSinceEpoch;

  static int get timem => timedate().microsecondsSinceEpoch;

  static String get times => DartiveAids.timedate().toString().split('.').first;

  static String get AmPm => timedate().hour > 12 ? 'PM' : 'AM';

  ///Use [delay] instead
  @deprecated
  static Future<T> delaySecond<T>([double second = 1, dynamic computation]) => Future.delayed(second.toDuration(), computation);

  static Future<T> delay<T>([double second = 1, dynamic computation]) => Future.delayed(second.toDuration(), computation);

  static T tryWith<T>(VCallbackT func, {onError, value}) {
    try {
      return func();
    } catch (e) {
      if (onError != null) return onError(e);
    }
    return value;
  }

  static var onTimeoutNull = ([v]) => null;

  ///
  ///=========================== Type ===========================
  ///

  static String type([dynamic o]) {
    if (o == null) return 'null';
    return '${o.runtimeType}';
  }

  static Map success(Object s, {Map? more}) => {'result': s, 'code': 1}.mergeInto(more);
  static Map error(Object s, {Map? more}) => {'result': s, 'code': -1}.mergeInto(more);

  ///
  ///=========================== Random ===========================
  ///

  static final int RandomId = Random().nextInt(0xFFFFFFFF);
  static int _current_increment = RandomId;

  static int get nextIncrement => _current_increment++;

  static String get objectId => '${timem.toOctet()}${nextIncrement.toOctet()}';

  @Deprecated('just use nextInt nextDouble nextBool')
  static Random get kRandom => Random(timem);

  static int nextInt(int max) {
    var i = Random(timem).nextInt(max);
    if (i == 0) return 1;
    return i;
  }

  static double nextDouble() => Random(timem).nextDouble();

  static bool nextBool() => Random(timem).nextBool();

  static String nextString(int length, {bool isCapital = false}) => ''.random(length, isCapital: isCapital);

  ///
  ///=========================== Time ===========================
  ///
  static DateTime timedate([dynamic input]) {
    if (input != null) {
      if (input is DateTime) return input;
      if (input is Duration) {
        if (isLocalUtc) return DateTime.now().toUtc().add(input);
        return DateTime.now().add(input);
      }
      if (input is int) return DateTime.fromMillisecondsSinceEpoch(input);
      if (!(input is String)) throw Exception('Wops! support only [int,duration,string]; not these [${input.runtimeType}] !!!');
      return DateTime.parse(input);
    }
    if (isLocalUtc) return DateTime.now().toUtc();
    return DateTime.now();
  }

  static String format(String s, {dynamic input, fx = ''}) {
    var date = timedate(input);
    return date.toFormat(format: s, fx: fx);
  }

  /// Generates a time-based ID using y-m-d h:i:s format.
  /// Example output: 2023-07-11-14:30:00-{random_string}

  static String timeId([dynamic input, String jo = '-']) => [format('ymd'), format('his'), input ?? nextString(10)].join(jo).toUpperCase();

  ///
  ///=========================== Token ===========================
  ///

  static String tokenGen(String sign, {Duration? duration}) {
    var expired = duration ?? Duration(days: 7);
    return [expired.inMilliseconds.toRadixString(16), sign, time.toRadixString(16)].join('-');
  }

  static String? tokenSign(String token) {
    try {
      if (token.isEmptyOrNull) return null;
      var tokens = token.split('-');
      if (tokens.length != 3) return null;
      return tokens[1];
    } catch (e) {
      return null;
    }
  }

  static bool tokenExpired(String token) {
    try {
      if (token.isEmptyOrNull) return true;
      var tokens = token.split('-');
      if (tokens.length != 3) return true;
      var expire = int.parse(tokens.first, radix: 16);
      var timed = int.parse(tokens.last, radix: 16);
      return (time - timed) > expire;
    } catch (e) {
      return true;
    }
  }

  ///
  ///=========================== Utilities|Convert|Math|Numbers ===========================
  ///

  static num px2cm(num m, [num dpi = 2.54]) => m / dpi;

  static num px2m(num m, [num dpi = 0.254]) => px2cm(m, dpi);

  static int m2px(num m, [int dpi = 300]) => ((dpi / 0.254) * m).round();

  static int cm2px(num cm, [int dpi = 300]) => ((dpi / 2.54) * cm).round();

  static int mm2px(num mm, [int dpi = 300]) => ((dpi / 25.4) * mm).round();

  static int lerpInt(int minV, int maxV, int value) => max(minV, min(value, maxV));

  static num degToRad(num deg) => deg * (pi / 180.0);

  static List<String> WEEKS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static List<String> MOONS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static String GMT([dynamic input]) => format('%w, %d %q %y %h:%i:%s GMT', input: input, fx: '%');

  static String ossCode(String sec, String option) => base64Encode(Hmac(sha1, sec.codeUnits).convert(option.codeUnits).bytes);

  ///--------------------------------------------IDFile--------------------------------------------
  static String idServer = '01';

  static String idPath(String id) {
    if (id.startsWith('/')) {
      return id.substring(1);
    }
    var ids = id.split('-');
    var ret = '';
    if (ids.first.isNotEmpty) ret += '${ids.first}/';
    if (ids.length > 1) ret += '${ids[1]}/';
    if (ids.length > 3) ret += '${ids.trySub(2, -1).join('-')}';
    return '${ret}.${ids.last}';
  }

  static String idExt(String id) => id.split('-').last;

  static String idExtTo(String id, String to) => (id.split('-').trySub(0, -1)..add(to)).join('-').toUpperCase();

  static String idFromId(String id, String fid) {
    var ids = id.split('-');
    var ext = ids.last;
    var fids = fid.split('.');
    if (fids.length >= 2) {
      ext = fids.last;
      fids.removeLast();
    }
    var nid = <String>[...ids.trySub(0, -1), ...fids, ext];
    return nid.join('-').toUpperCase().replaces('--', '-');
  }

  static String idSerNew(String id, {String? ser}) {
    var ids = id.split('-');
    var ext = ids.last;
    if (ext.isEmpty || ext == null.toString()) ext = 'none';
    return '${ser ?? idServer}-${timeId(''.random(4, isCapital: true))}-${ext.tryCut(5)}'.toUpperCase();
  }

  static String idUrl(String id) => '/${idPath(id)}';

  ///--------------------------------------------Checker--------------------------------------------

  static Map<String, Duration> mapChecker = {};

  static bool checkerIn(String key, [double second = 1]) {
    if (mapChecker.has(key)) {
      Duration time = mapChecker[key]!;
      if (time.timeOut(second.toDuration())) {
        mapChecker[key] = duration;
        return true;
      }
      return false;
    }
    mapChecker[key] = duration;
    return true;
  }

  static bool checkerOut(String key, [double second = 1]) => !checkerIn(key, second);
}
