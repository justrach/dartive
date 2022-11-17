part of 'dartiveAid.dart';

extension DartiveAidsExtensionNum on num {
  num lerp(num from, num to) {
    if (isNull) return from;
    return max(min(this, to), from);
  }

  /// Todo this function not tested on ios
  T random<T>({bool isCapital = false, bool isId = false, chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'}) {
    var max = toInt();
    if (T is int) return DartiveAids.nextInt(max) as T;
    if (T is double) return DartiveAids.nextDouble() * max as T;
    if (T is bool) return DartiveAids.nextBool() as T;
    var s = '${DartiveAids.timem.toOctet()}${DartiveAids.RandomId.toOctet()}${DartiveAids.nextIncrement.toOctet()}';
    return s as T;
  }

  String toOctet({int len = 8}) {
    var value = toInt();
    var res = value.toRadixString(16);
    while (res.length < len) {
      res = '0$res';
    }
    return res;
  }

  Duration toDuration() {
    var seconds = floor();
    var after = (this - seconds) * 10000;
    var mil = 0, mic = 0;
    if (after > 0) {
      var ms = after.toString().padLeft(6, '0').substring(0, 6);
      mil = ms.substring(0, 3).tryTo<int>() ?? 0;
      mic = ms.substring(3).tryTo<int>() ?? 0;
    }
    return Duration(seconds: seconds, milliseconds: mil, microseconds: mic);
  }

  String toByteString({String format = 'PB', int fixed = 2}) {
    var size = this;
    var Kb = 1024;
    var Mb = Kb * 1024;
    var Gb = Mb * 1024;
    var Tb = Gb * 1024;
    var Pb = Tb * 1024;
    var ret = size;
    if (size < Kb || format == 'B') {
      ret = size;
    } else if (size < Mb || format == 'KB') {
      ret = size / Kb;
    } else if (size < Gb || format == 'MB') {
      ret = size / Mb;
    } else if (size < Tb || format == 'GB') {
      ret = size / Gb;
    } else if (size < Pb || format == 'TB') {
      ret = size / Tb;
    } else {
      ret = size / Pb;
    }
    return ret.toStringAsFixed(fixed) + format.toUpperCase();
  }

  String digits([int digit = 0]) => '$this'.padLeft(digit, '0');

  String toView([int digit = 0]) {
    var ip = this;
    if (ip.isNull) return '0';
    var size = ip / 1.0;

    var z = size / 100000000000000;
    var j = size / 1000000000000;
    var t = size / 10000000000;
    var b = size / 100000000;
    var m = size / 1000000;
    var w = size / 10000;
    var k = size / 1000;

    if (z >= 100) return z.toStringAsFixed(digit) + 'z';
    if (j >= 100) return j.toStringAsFixed(digit) + 'j';
    if (t >= 100) return t.toStringAsFixed(digit) + 't';
    if (b >= 100) return b.toStringAsFixed(digit) + 'b';
    if (m >= 100) return m.toStringAsFixed(digit) + 'm';
    if (w >= 100) return w.toStringAsFixed(digit) + 'w';
    if (k >= 100) return k.toStringAsFixed(digit) + 'k';
    return ip.toStringAsFixed(digit).toString();
  }
}

extension DartiveAidsExtensionInt on int {
  void loop(Function(int) next) {
    for (var i = 0; i < this; i++) {
      next(i);
    }
  }
}
