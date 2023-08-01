part of 'dartiveAid.dart';

extension DartiveAidsExtensionDateTime on DateTime {
  /// The y=year [0001..infinity].
  /// The m=month [1..12].
  /// The d=day of the month [1..31].
  /// The h=hour of the day, expressed as in a 24-hour clock [0..23].
  /// The i=minute [0...59].
  /// The s=second [0...59].
  /// The ms=millisecond [0...999].
  /// The us=microsecond [0...999].
  String toFormat({String format = 'y-m-d h:i:s', String fx = ''}) {
    var date = this;
    var s = format;
    s = s.replaceAll('${fx}w', DartiveAids.WEEKS[date.weekday - 1]);
    s = s.replaceAll('${fx}q', DartiveAids.MOONS[date.month - 1]);

    s = s.replaceAll('${fx}ms', date.millisecond.digits(3));
    s = s.replaceAll('${fx}us', date.microsecond.digits(3));

    s = s.replaceAll('${fx}y', date.year.digits(4));
    s = s.replaceAll('${fx}m', date.month.digits(2));
    s = s.replaceAll('${fx}d', date.day.digits(2));

    s = s.replaceAll('${fx}h', date.hour.digits(2));
    s = s.replaceAll('${fx}i', date.minute.digits(2));
    s = s.replaceAll('${fx}s', date.second.digits(2));
    if (date.isUtc) {
      s = [s, 'Z'].join();
    }
    return s;
  }

  String toStr() {
    return toString().split('.').first;
  }
}

extension DartiveAidsExtensionDuration on Duration {
  String toSString() {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }
    var twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration get elapse => diff();
  String get firstPart => toString().split('.').first;
  double get elapseSec => double.parse((elapseMs / 1000).toStringAsFixed(3));
  double get elapseMs => double.parse((elapseMc / 1000).toStringAsFixed(3));
  double get elapseMc => elapse.inMicroseconds.toDouble();

  Duration diff([Duration? other]) => (other ?? DartiveAids.duration) - this;

  bool timeOut(Duration s) => elapse > s;

  bool outSide(Duration s) =>s > this;
  bool inSide(Duration s) =>s < this;

  bool between(Duration start, Duration end) {
    var current=this;
    if (end < start) end += Duration(hours: 24);
    return start <= current && current <= end;
  }
}
