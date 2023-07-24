import 'package:dartive/dartive.dart';
import 'package:dartive/dartiveMongo.dart';
import 'dart:io' show Platform;

import 'package:mongo_dart/mongo_dart.dart';

String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '0.0.0.0';
String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';

void main(List<String> arguments) async {

  var uri = 'mongodb://$host:$port/mongo_dart-blog';

  /// Create a client
  var client = await DartiveMongo.client(uri);
  /// connect

  await client.open();

  /// find
  DartiveMongo.find({'name': 'Tom', 'rating': {r'$gt': 10}}, "name, friends", () async {
    return {
      "name": "Tom",
      "friends": {"John", "Jane"}
    };
  });

  /// findOne
  /// insertMany
  /// insertAll
  /// insertOne
  /// replaceOne
  /// updateOne
  /// updateMany
  /// deleteOne
  /// deleteMany
  /// close connection
  await client.close();


  // comment
  await Dartive.listen(host: '0.0.0.0', port: 8000);
}