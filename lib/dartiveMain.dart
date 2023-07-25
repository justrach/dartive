import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:dartive/src/dartiveAid.dart';
import 'package:mime/mime.dart';
class Dartive {
  static String version = '1.0';
  static String autoKey = 'AUTO';
  static int reqLimit = 1048576;

  // String get token =>
      // jsons.tryTo<Map>().get<String>('token') ?? req.headers.value('token');
 static Future<Isolate> spawnIsolate(FutureOr<void> Function(SendPort sendPort) entryPoint) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(entryPoint, receivePort.sendPort);
    return isolate;
  }
  static Map success(dynamic s, {dynamic msg = 'success'}) =>
      {'msg': msg, 'code': 1, 'result': s};

  static bool isSuccess(dynamic o) =>
      o != null && o is Map && o.containsKey('code') && o['code'] == 1;

  static Map error(dynamic s) => {'msg': '$s', 'code': -1};

  static bool isError(dynamic o) => !isSuccess(o);

  Dartive(this.req);

  var request;

  HttpRequest req;

  /// Getters

  bool get isPost => method == 'POST';

  bool get isGet => method == 'GET';

  Uri get uri => req.requestedUri;

  String? get ip => req.connectionInfo?.remoteAddress.host;

  int? get port => req.connectionInfo?.remotePort;

  String get method => req.method;

  ContentType? get type => req.headers.contentType;

  HttpResponse get res => req.response;

  /// Get boundary for multi-part processing

  String? get boundary => (type != null && type?.parameters != null)
      ? type?.parameters['boundary']
      : null;

  bool get isXForm =>
      type != null && type.toString().contains('x-www-form-urlencoded');

  bool get isForm => boundary != null;

  int reqLength = -1;
  int resLength = -1;

  Stream<List<int>> get stream => req;

  Map jsons = {};

  String get pathQuery => uri.path;
   Map<String,String> get queryParameters => uri.queryParameters;

  Map<String, String> reqHeaders = {};

  var time = DartiveAids.duration;

  // late WebSocket ws;

  // void handle() async {
  //   resHeaders['Server'] = '${resHeaders['Server']}-${version}';
  //   resHeaders.forEach(res.headers.set);
  //   req.headers.forEach((name, values) => reqHeaders[name] = values.join(';'));
  //   Object ret;
  //   try {
  //     reqLength = req.contentLength;
  //     logger('[Req] $method $uri $reqLength', 'D');
  //     if (reqLength > reqLimit)
  //       throw Exception(
  //           'Content length ${reqLength}/${reqLimit} out of request limit!!!');
  //     var call = match(method, uri);
  //     ret = await callable(call);
  //     if (ret is Error || ret is Exception || ret is Future<Error>)
  //       throw Exception(ret.toString());
  //     await write(ret);
  //   } catch (e, t) {
  //     var id = DartiveAids.timeId();
  //     logger('[$id]$e\n${t.toString().split('\n').first}', 'E');
  //     res.statusCode = HttpStatus.internalServerError;
  //     await write(Dartive.error('Server Error Id=$id !!!'));
  //   }
  //   // if (ws!=null) return null;
  //   await close;
  //   return null;
  // }
  Future<void> handle() async {
    // resHeaders['Server'] = '${resHeaders['Server']}-${version}';
    resHeaders.forEach(res.headers.set);
    req.headers.forEach((name, values) => reqHeaders[name] = values.join(';'));
    Object ret;
    try {
      reqLength = req.contentLength;
      logger('[Req] $method $uri $reqLength', 'D');
      if (reqLength > reqLimit)
        throw Exception(
            'Content length ${reqLength}/${reqLimit} out of request limit!!!');
      var call = match(method, uri);
      ret = await callable(call);
      print(ret.toString());
      if (ret is Error || ret is Exception || ret.isNull)
        throw Exception(ret.toString());
      await write(ret);
    } catch (e, t) {
      var id = DartiveAids.timeId();
      logger('[$id]$e\n${t.toString().split('\n').first}', 'E');
      res.statusCode = HttpStatus.internalServerError;
      await write(Dartive.error('Server Error Id=$id !!!'));
    }
    // if (ws.isNotNull) return;
    await close();
  }
  bool has<T>(Object key, [Object? val]) {
    if (isEmptyOrNull) return false;
    Map o = this as Map;
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
  Future<void> write(Object input) async {
    // if (ws!=null) return;
    if (input is String) {
      res.headers.set('Content-Type', 'text/plain; charset=UTF-8');
      writeToStr(input);
    } else if (input is List) {
      res.headers.set('Content-Type', 'application/json; charset=UTF-8');
      writeToStr(json(input));
    } else if (input is Map) {
      res.headers.set('Content-Type', 'application/json; charset=UTF-8');
      writeToStr(json(input));
    } else if (input is File) {
      if (input.existsSync()) {
        if (uri.queryParameters.has('down')) {
          var filename = uri.queryParameters.get<String>('down', '').trim();
          // if (filename.isEmptyOrNull) filename = input.();
          res.headers
              .set('Content-Disposition', 'attachment;filename=${filename}');
        }
        var resETags =
            '${input.lengthSync()}-${input.lastModifiedSync().microsecondsSinceEpoch}';
        var reqETag = req.headers.value('if-none-match');
        if (reqETag == resETags) {
          res.statusCode = HttpStatus.notModified;
          return null;
        } else {
          res.headers.set('Content-Type',
              lookupMimeType(input.path) ?? 'text/plain; charset=UTF-8');
          res.headers.set('ETag', resETags);
          resLength = input.lengthSync();
          await input.openRead().pipe(res);
          return null;
        }
      }
      res.statusCode = HttpStatus.notFound;
      return await write(Dartive.error('file not exists 404'));
    } else {
      writeToStr(input.toString());
    }
  }

  void writeToStr(String input) async {
    resLength += input.length;
    res.write(input);
  }

  /// User can extend this method
  Future<Object> callable(dynamic call) async {
    if (call is Function()) {
      return await call();
    } else if (call is Function(Dartive)) {
      if (isParsePost) {
        await parsePost();

      };
      return await call(this);
    } else if (call is Function(Uri)) {
      return await call(uri);
    } else if (call is Function(HttpRequest, HttpResponse)) {
      return await call(req, res);
    } else if (call is Function(HttpRequest)) {
      return await call(req);
    } else if (call is Function(HttpResponse)) {
      return await call(res);
    } else if (call is Future) {
      return callable(await call);
    }
    return call;
  }

  static void get(pattern, func) => route('get', pattern, func);

  static void post(pattern, func) => route('post', pattern, func);

  static void auto(pattern, func) => route(autoKey, pattern, func);

  static void put(pattern, func) => route('put', pattern, func);

  static void delete(pattern, func) => route('delete', pattern, func);

  static void option(pattern, func) => route('option', pattern, func);

  /// A two-dimensional map that holds all created routes in the form of {}. <br>
  /// The outer keys of routeMap are of type [String] and represent the request method. <br>
  /// The inner keys of routeMap are of type [dynamic] and represent the URI pattern for the route. <br>
  /// The inner value of routeMap contains the function handler of the route

  static Map<String, dynamic> routeMap = {};
  static Map<String, String> get resHeaders => {
    'Server': 'Dartive $version',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': '*',
    'Access-Control-Allow-Headers': '*',
    'Content-Type': 'application/json; charset=utf-8',
  };

  static bool isParsePost = true;

  /// register route to routeMap
  static void route(String method, dynamic pattern, dynamic func) {
    method = method.toUpperCase();
    if (!routeMap.containsKey(method)) routeMap[method] = <dynamic, dynamic>{};
    routeMap[method][pattern] = func;
  }

  /// route matcher
  static dynamic _matcher;

  static Object matcher(Function(Uri) func) => _matcher = func;
  //
  // static Object tester(String method, Uri uri) {
  //   ///todo
  // }


  /// Matches the method and URI request provided to an existing route in routeMap. <br>
  /// Returns the handler function associated with the route.

  static Object match(String method, Uri uri) {
    var pathQuery = uri.path;
    dynamic next;

    /// find a matcher function if it exists and call it on the uri provided. <br>
    /// if matcher(uri) returns a route, return the route. <br>
    /// else first look for auto-routes and lastly static routes. <br>
    if (_matcher != null) {
      next = _matcher(uri);
      if (next != null) return next;
    }
    routeFind(Map routes) {
      if (routes.containsKey(pathQuery)) return routes[pathQuery];
      for (String key in routes.keys) {
        var regKey = key.startsWith('/') ? '^$key' : key;
        if (RegExp(regKey).hasMatch(pathQuery)) return routes[key];
      }
      ;
      return null;
    }

    /// find automatic routes
    dynamic routes = Map.from(routeMap[autoKey] ?? {});
    next = routeFind(routes);
    if (next != null) return next;

    /// find static routes based on request method
    routes = Map.from(routeMap[method.toUpperCase()] ?? {});
    next = routeFind(routes);
    if (next != null) return next;

    return Dartive.error('Not found pathQuery: "${pathQuery}" with method:$method');
  }

  /// post parser for Forms, XForms and JSON
  Future<void> parsePost() async {
    if (isForm) {
      var maps = await parseForms()?.toList();
      var _jsons = {};
       maps?.forEach((element) async {
         element.forEach((key, value) async {
          if (value is Future<String>) {
            _jsons[key] = await value;
          } else {
            _jsons[key] = value;
          }
        });
      });
      jsons = _jsons.mergeInto(jsons);
    } else if (isXForm) {
      await parseXForms();
    } else {
      await parseJson();
    }
    await parseUrls();
  }

  Future<Map> parseJson() async {
    try {
      var input = await utf8.decoder.bind(req).join();
      if (input=="") jsons = jsonDecode(input);
      request = input;
      // print(input);
    } catch (e) {
      Dartive.logger('parseJson $e', 'E');
    }
    return jsons;
  }

  Future<Map> parseUrls() async {
    try {
      jsons.mergeInto(uri.queryParameters);
    } catch (e) {
      Dartive.logger('parseUrls $e', 'E');
    }
    return jsons;
  }

  ///example a=b&c=d
  Future<Map?> parseXForms([bool ignoreFile = true]) async {
    if (!isXForm) return null;
    try {
      var input = await utf8.decoder.bind(req).join();
      var _jsons = {};
      input.formUrlDeCode().forEach((key, value) {
        _jsons[key] = value;
      });
      jsons = _jsons.mergeInto(jsons);
    } catch (e) {
      Dartive.logger('parseXForms $e', 'E');
    }
    return jsons;
  }

  /// Returns eg. ```{name: foo, val: Instance of '_MimeMultipart'}```
  Stream<Map>? parseForms() {
    if (boundary == null) return null;
    return MimeMultipartTransformer(boundary!).bind(req).map((event) {
      var input = Map.from(event.headers);
      var k = 'content-disposition';
      if (input.containsKey(k)) {
        input[k].replaceAll('form-data;', '').split(';').forEach((element) {
          var kv = element.toString().trim().split('=');
          input[kv.first.trim()] = kv.last.trim().replaceAll('"', '');
        });
        input.remove(k);
      }
      dynamic key = input['name'];
      dynamic val;
      if (input.length == 1) {
        val = utf8.decoder.bind(event).join();
      } else {
        // input.key('filename', 'name');
        input['file'] = event;
        val = input;
      }
      return {key: val};
    });
  }

  static Future<StreamSubscription<HttpRequest>> listen(
      {int port = 4040,
        String host = '0.0.0.0',
        dynamic onStart,
        dynamic onComplete}) async {
    var server = await HttpServer.bind(host, port);
    logger('Listening on http://$host:$port/', 'I');
    return server.listen((request) async {
      var api = Dartive(request);
      // print("the request is ${request}");
      try {
         var x = api.handle();
         print(x);
      } catch (e, t) {
        logger('Request.Error [${api.uri}] $e,$t', 'E');
      }
    });
  }

  static String json(dynamic input) =>
      jsonEncode(input, toEncodable: (o) => o.toString());

  /// User can customize this function for db or any file to output the log message <br>
  /// The first optional parameter, [object] will be the message <br>
  /// The Second optional parameter, [level] will be the log level, e.g Debug, Error, Info..., default value is 'I'
  static Function([dynamic, dynamic]) logger =
    ([object, level = 'I']) async => print('${DartiveAids.timeId()}: Type: [$level] | Info: $object');


  bool _closed = false;

  Future<void> close() async {
    if (_closed) return;
    logger(
        '[Res] $pathQuery ($resLength-${time.elapseMs}/ms) ${res.statusCode}',
        'D');
    try {
      _closed = true;
      await res.close();
    } catch (e) {}
  }
}
