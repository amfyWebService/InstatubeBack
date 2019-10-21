library instatube_service.src.config.plugins;
import 'package:mongo_dart/mongo_dart.dart';

import 'dart:async';
import 'package:angel_framework/angel_framework.dart';

Future configureServer(Angel app) async {
  // Include any plugins you have made here.
  var db = new Db(app.configuration['mongo_db'] as String);
  await db.open();
  app.container.registerNamedSingleton("mongoDb",db);
}
