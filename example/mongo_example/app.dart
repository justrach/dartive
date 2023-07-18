import 'package:dartive/dartive.dart';
import 'package:dartive/dartiveMongo.dart';

void main(List<String> arguments) async {

  /// connect


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
  /// disconnect


  // comment
  await Dartive.listen(host: '0.0.0.0', port: 8000);
}