/// TODO a mongo ORM for simple CRUD functionality.
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dartive/dartive.dart';



class DartiveMongo {
  /// Private constructor to create a DartiveMongo Client around mongo_dart's Db class
  /// TODO add Dartive logger for debugging
  // final Db _db;
  // DartiveMongo(String uri): _db = Db(uri);
  

  late Future<Db> _db;

  /// Creates a mongoDB client and is able to handle connection for both standard format and DNS seedlist (SRV) format.
  DartiveMongo(String uri) {
    _db = Db.create(uri);
  }

  Future<void> open() async => await (await _db).open();
  

  
  static Future<Db> client(String uriString, [bool useMongoDart = false]) async {
    if (useMongoDart) {
      try {
        return Db.create(uriString);
      } catch (e) {
        throw Dartive.logger('Error creating connection: $e');
      }
    } else throw Dartive.logger('TODO');
    
  }
  

  

  // await db.open();


  static void find(query, projection, [options]) => null;


  Future<void> close() async => await (await _db).close();
}
