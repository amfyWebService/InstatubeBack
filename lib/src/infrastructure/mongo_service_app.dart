import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:instatube_service/src/infrastructure/no_connection_found.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Find or create an mongo store for [collectionName].
MongoService mongoServiceApp(Angel app, String collectionName) {
  const key = 'mongoDb';

  // If there is already an existing singleton, return it.
  if (!app.container.hasNamed(key)) {
    throw NoConnectionFound();
  }
  var db = app.container.findByName<Db>(key);
  return MongoService(db.collection(collectionName));
}
