/// TODO a mongo ORM for simple CRUD functionality.
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dartive/dartive.dart';



class DartiveMongo {
  static String todo = "Hello World!";

  /// Handles connection for both standard format and DNS seedlist (SRV) format.
  Future<Db> connect(String uri) async {
    var db;
    try {
      if (uri.startsWith("mongodb://")) {
        db = Db(uri);
      } else if (uri.startsWith("mongodb+srv://")) {
        db = await Db.create(uri);
      }
    } catch (e) {
      Dartive.logger('Error creating connection: $e');
    }
    return db;
  }

  // await db.open();


  static void find(query, projection, [options]) => todo;

}
