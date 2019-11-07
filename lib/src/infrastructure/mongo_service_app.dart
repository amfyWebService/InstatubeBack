import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Find or create an mongo store for [collectionName].
Service mongoServiceApp(Angel app, String collectionName) {
  const key = 'mongoDb';

  // If there is already an existing singleton, return it.
  if (!app.container.hasNamed(key)) {
    return inMemoryService(app, collectionName);
  }
  var db = app.container.findByName<Db>(key);
  return MongoService(db.collection(collectionName));
}

MapService inMemoryService(Angel app, String collectionName) {
  // If there is already an existing singleton, return it.
  if (app.container.hasNamed(collectionName)) {
    return app.container.findByName<MapService>(collectionName);
  }

  // Create an in-memory service. We will use this
  // as the backend to store Todo objects, serialized to Maps.
  var mapService = MapService();

  // Register this service as a named singleton in the app container,
  // so that we do not inadvertently create another instance.
  app.container.registerNamedSingleton(collectionName, mapService);

  return mapService;
}
