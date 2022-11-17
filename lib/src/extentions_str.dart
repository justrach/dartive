part of 'dartiveAid.dart';

extension DartiveAidsExtensionString on String {
  String toLo() => toLowerCase();
  String toUp() => toUpperCase();
  int toInt([int def = 0]) => int.tryParse(this) ?? def;
  //
  String toUpFirst() {
    if (isEmptyOrNull) return this;
    if (length < 2) return toUp();
    return substring(1).toUp() + substring(1);
  }

  String withTo(Object o) => this + '$o';
  //
  String random(int length, {bool isCapital = false}) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    if (isCapital) chars = chars.substring(0, 36);
    final buf = StringBuffer();
    for (var x = 0; x < length; x++) {
      buf.write(chars[DartiveAids.nextInt(chars.length)]);
    }
    return this + buf.toString();
  }

  Map formUrlDeCode() {
    var jsonData = {};
    for (var element in split('&')) {
      var els = element.split('=');
      jsonData[Uri.decodeFull(els.first)] = Uri.decodeFull(els.last);
    }
    return jsonData;
  }

  //
  String trySub(int start, [int? end]) {
    if (start.isNegative) {
      return substring(start + length);
    } else {
      return substring(start, end != null ? min(end, length) : null);
    }
  }

  String tryCut(int len) => trySub(0, len);
  Uri toUri() => Uri.parse(this);
  String urlEncode() => Uri.encodeQueryComponent(this);
  String urlDecode() => Uri.decodeQueryComponent(this);
  String toMd5() => md5.convert(codeUnits).toString();
  String toBase64() => base64Encode(codeUnits);
  String toHex() => hex.encode(codeUnits);
  String toHexStr() => hex.decode(this).tryUtf8();
  List<int> toHexByte() => hex.decode(this);
  String toBase64Str() => base64Decode(this).tryUtf8();

  String tryReplace({int times = 20, String from = '****', String to = '***'}) {
    var string = toString();
    for (var i = 0; i < times; i++) {
      string = string.replaceAll(from, to);
    }
    return string;
  }

  //
  String replaces(reg, [String to = '']) {
    if (reg is List) {
      var str = this;
      var i = 0;
      for (var r in reg) {
        if (to is List) {
          str = str.replaceAll(r, to[i]);
        } else {
          str = str.replaceAll(r, to);
        }
        i++;
      }
      return str;
    }
    return replaceAll(reg, to);
  }

  Duration toDuration() {
    var parts = split('.');
    var mil = 0, mic = 0;
    if (parts.length >= 2) {
      var ms = parts.last.toString().padRight(6, '0');
      mil = ms.substring(0, 3).tryTo<int>() ?? 0;
      mic = ms.substring(3).tryTo<int>() ?? 0;
    }
    var arr = parts.first.split(':');
    var arr0 = arr.first.tryTo<int>() ?? 0;
    if (arr.length == 1) return Duration(hours: arr0, milliseconds: mil, microseconds: mic);
    var arr1 = arr[1].tryTo<int>() ?? 0;
    if (arr.length == 2) return Duration(hours: arr0, minutes: arr1, milliseconds: mil, microseconds: mic);
    var arr2 = arr[2].tryTo<int>() ?? 0;
    return Duration(hours: arr0, minutes: arr1, seconds: arr2, milliseconds: mil, microseconds: mic);
  }

  List<String> chunck({int len = 1, val}) {
    if (isNull || isEmpty) return val;
    var res = <String>[];
    var i = 0;
    while (i < length) {
      res.add(trySub(i, i + len));
      i = i + len;
    }
    return res;
  }

  String get reversed => String.fromCharCodes(runes.toList().reversed);

  bool compareVersion(String ver) {
    var old = this;
    var upgrade = false;
    if (old != ver) {
      var nvl = ver.replaceAll('+', '.').split('.');
      var ovl = old.replaceAll('+', '.').split('.');
      if (nvl.length != ovl.length) {
        upgrade = true;
      } else {
        for (var i = 0; i < nvl.length; i++) {
          var nvln = int.tryParse(nvl[i]) ?? 0;
          var ovln = int.tryParse(ovl[i]) ?? 0;
          if (nvln > ovln) {
            upgrade = true;
            break;
          }
          if (nvln < ovln) break;
        }
      }
    }
    return upgrade;
  }
}
