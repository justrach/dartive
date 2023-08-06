import 'package:mongo_dart/mongo_dart.dart';
import 'package:dartive/dartive.dart';
// export 'package:mongo_dart/mongo_dart.dart';
export 'package:mongo_dart_query/mongo_dart_query.dart';

/// A mongo ORM for simple CRUD functionality that follows the same syntax as MongoNodeJs driver. <br>
/// Note that this is a wrapper and not an extension, hence it will incur some overhead and performance hits.

class DartiveMongo {
  /// Private constructor to create a DartiveMongo wrapper around mongo_dart's Db class
  final Db _db;
  DartiveMongo._(this._db);
  
  /// Getters
  bool get modernMongo => _db.masterConnection.serverCapabilities.supportsOpMsg;

  /// Public factory constructor that <br>
  /// creates a mongoDB client and is able to handle connection for both standard format and DNS seedlist (SRV) format.
  /// TODO: provide support for using mongoDart directly
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
    return DartiveCollection(_db, collectionName, this);
  }
  


  Future<void> close() async => await (await _db).close();
}

// TODO: improve all the querys to resemble nodeJS driver syntax

class DartiveCollection {
  final DartiveMongo _dartiveMongo;
  late DbCollection _collection;

  DartiveCollection(Db _db, String collectionName, this._dartiveMongo) {
    _collection = _db.collection(collectionName);
  }

  Future<bool> drop() {
    return _collection.drop();
  }

///--------------------------------------------Find--------------------------------------------

  /// findOne method allows mongo_dart selector as well as NodeJS driver format of filter, projection.
  Future<Map<String, dynamic>?> findOne([dynamic query, dynamic projection]) {
    if (query != null && projection == null) {
      return _collection.findOne(query);
    } else if (query != null && projection != null) {
      if (_dartiveMongo.modernMongo) {
      return _collection.modernFindOne(filter: query, projection: projection);
      } else {
        return legacyFinder(query, projection);
      }
    } else if (query is SelectorBuilder && projection != null) {
      throw Dartive.logger('Please use .fields chaining method for projections with SelectorBuilders', 'E');
    }

    throw Dartive.logger('Invalid query format, please follow the correct format', 'E');
    
  }

  Stream<Map<String, dynamic>> find([selector]) {
    return _collection.find(selector);
  }

  Future<Map<String, dynamic>?> legacyFinder([dynamic query, dynamic projection]) async {
    var result = await _collection.legacyFindOne(query);
    Map<String, dynamic> res = {};
    projection.forEach((field, value) {
      if (value == 1) {
        res[field] = result?[field];
      }
    });
    return res;
  }


///--------------------------------------------Insert--------------------------------------------

  Future<Map<String, dynamic>> insertOne(Map<String, dynamic> document) async {
    return await _collection.insert(document);
  }

  Future<BulkWriteResult> insertMany(List<Map<String, dynamic>> documents) async {
    return await _collection.insertMany(documents);
  }

  Future<Map<String, dynamic>> insertAll(List<Map<String, dynamic>> documents, {WriteConcern? writeConcern}) async {
    return await _collection.insertAll(documents, writeConcern: writeConcern);
  }

  ///--------------------------------------------Delete--------------------------------------------
  
  Future<WriteResult> deleteOne(selector,
      {WriteConcern? writeConcern,
      CollationOptions? collation,
      String? hint,
      Map<String, Object>? hintDocument}) {
    return _collection.deleteOne(selector,
        writeConcern: writeConcern,
        collation: collation,
        hint: hint,
        hintDocument: hintDocument);
  }
  
  Future<Map<String, dynamic>> deleteMany(query, {WriteConcern? writeConcern}) {
    return _collection.remove(query, writeConcern: writeConcern);
  }
  ///--------------------------------------------Update & Replace--------------------------------------------
  
  Future<WriteResult> updateOne(selector, update,
      {bool? upsert,
      WriteConcern? writeConcern,
      CollationOptions? collation,
      List<dynamic>? arrayFilters,
      String? hint,
      Map<String, Object>? hintDocument}) async {
    return _collection.updateOne(selector, update,
        upsert: upsert,
        writeConcern: writeConcern,
        collation: collation,
        arrayFilters: arrayFilters,
        hint: hint,
        hintDocument: hintDocument);
  }


  Future<Map<String, dynamic>> updateMany(selector, document,
      {bool upsert = false,
      bool multiUpdate = true,
      WriteConcern? writeConcern}) async {
    return _collection.update(selector, document,
        upsert: upsert, multiUpdate: multiUpdate, writeConcern: writeConcern);
  }

  /// Universal update and replace function, can achieve updateOne, updateMany and replace depending on arguments passed to it.
  Future<Map<String, dynamic>> update(selector, document,
      {bool upsert = false,
      bool multiUpdate = true,
      WriteConcern? writeConcern}) async {
    return _collection.update(selector, document,
        upsert: upsert, multiUpdate: multiUpdate, writeConcern: writeConcern);
  }

  Future<Map<String, dynamic>?> findAndModify(
      {query,
      sort,
      bool? remove,
      update,
      bool? returnNew,
      fields,
      bool? upsert}) async {
    return _collection.findAndModify(
        query: query,
        sort: sort,
        remove: remove,
        update: update,
        returnNew: returnNew,
        fields: fields,
        upsert: upsert);
  }

  Future<WriteResult> replaceOne(selector, Map<String, dynamic> update,
      {bool? upsert,
      WriteConcern? writeConcern,
      CollationOptions? collation,
      String? hint,
      Map<String, Object>? hintDocument}) {
    return _collection.replaceOne(selector, update,
        upsert: upsert,
        writeConcern: writeConcern,
        collation: collation,
        hint: hint,
        hintDocument: hintDocument);
  }

  // TODO findOneAndReplace

}
