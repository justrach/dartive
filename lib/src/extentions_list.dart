part of 'dartiveAid.dart';

extension AlmExtensionList<E> on List<E> {
  int get size => isEmptyOrNull ? 0 : this.length;
  int get randomIndex => Random().nextInt(size);

  String toHex() => hex.encode(List.from(this));
  String tryUtf8() => utf8.decode(List.from(this), allowMalformed: true);

  List<E> trySub(int start, [int? end]) => sublist(min(length, end == null ? length : (end.isNegative ? max(length + end, 0) : end)));
  List<E> tryCut(int len) => trySub(0, len);

  List<List<E>> chunker({int size = 2}) {
    var len = this.size;
    var chunks = <List<E>>[];
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      chunks.add(sublist(i, end).cast<E>());
    }
    return List.from(chunks);
  }

  void foreachIndex(Function(E, int) forx) {
    var index = 0;
    forEach((element) {
      forx(element, index);
      index++;
    });
  }

  E get(int key, E val) {
    if (key < size) return this[key];
    return val;
  }

  E? val(int key) {
    if (key < size) return this[key];
    return null;
  }

  bool has(Object key) {
    if (isEmptyOrNull) return false;
    return contains(key);
  }

  get random => isEmptyOrNull ? null : this[randomIndex];

  List<E> cutRandomSize(int len) {
    var res = <E>[];
    var ks = [];
    while (len > 0) {
      var k = randomIndex;
      if (!ks.contains(k)) {
        ks.add(k);
        res.add(this[k]);
        len--;
      }
    }
    return List.from(res);
  }
}
