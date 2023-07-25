/// TODO a mongo ORM for simple CRUD functionality.
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dartive/dartive.dart';




class DartiveMongo {
  /// Private constructor to create a DartiveMongo wrapper around mongo_dart's Db class
  final Db _db;
  // DartiveMongo(String uri): _db = Db(uri);
  DartiveMongo._(this._db);
  

  /// Public factory constructor that <br>
  /// creates a mongoDB client and is able to handle connection for both standard format and DNS seedlist (SRV) format.
  static Future<DartiveMongo> client(String uriString, [bool useMongoDart = false]) async {
    try {
      final db = await Db.create(uriString);
      return DartiveMongo._(db);
    } catch (e) {
      throw Dartive.logger('Error creating connection: $e');
    }
  }



  /// Drop collection to clear the database
  Future<bool> dropCollection(String collectionName) async => await _db.dropCollection(collectionName);

  /// Connects to the mongoDB using open
  Future<void> connect() async => await _db.open();

  /// Finds the mongoDB collection specified
  DartiveCollection collection(String collectionName) {
    return DartiveCollection(_db, collectionName);
  }
  


  Future<void> close() async => await (await _db).close();
}


class DartiveCollection {

  late DbCollection _collection;

  DartiveCollection(Db _db, String collectionName) {
    _collection = _db.collection(collectionName);
  }


  Future<Map<String, dynamic>?> findOne([selector]) {
    return _collection.findOne(selector);
  }

  Future<Map<String, dynamic>> remove(selector, {WriteConcern? writeConcern}) {
    return _collection.remove(selector, writeConcern: writeConcern);
  }

  Future<Map<String, dynamic>> insertOne(Map<String, dynamic> document) async {
    return await _collection.insert(document);
  }

  Future<BulkWriteResult> insertMany(List<Map<String, dynamic>> documents) async {
    return await _collection.insertMany(documents);
  }


  static void find(query, projection, [options]) => null;
}
