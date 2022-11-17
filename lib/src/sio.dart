
class Notifyer<T>{
  final List<Function(T?)> _notifyer = [];
  void pub([T? tag]) {
    _notifyer.forEach((listener) {
      listener(tag);
    });
  }
  void dis(Function(T?) val) {
    _notifyer.remove(val);
  }
  void sub(Function(T?) val) {
    _notifyer.add(val);
  }
}
