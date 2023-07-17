import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class Root {
  Root({
    required this.hello,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
        hello: asT<String>(json['Hello'])!,
      );

  String hello;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Hello': hello,
      };

  Root copy() {
    return Root(
      hello: hello,
    );
  }
}
