library instatube_service.src.interface.services;

import 'dart:async';

import 'package:angel_framework/angel_framework.dart';

Future configureServer(Angel app) async {
//  var auth = AngelAuth<User>();
//  auth.serializer = ...;
//  auth.deserializer = ...;
//  auth.strategies['local'] = LocalAuthStrategy(...);
//
//  // POST route to handle username+password
//  app.post('/local', auth.authenticate('local'));
//
//  // Using Angel's asynchronous injections, we can parse the JWT
//  // on demand. It won't be parsed until we check.
//  app.get('/profile', ioc((User user) {
//  print(user.description);
//  }));
//
//  // Use a comma to try multiple strategies!!!
//  //
//  // Each strategy is run sequentially. If one succeeds, the loop ends.
//  // Authentication failures will just cause the loop to continue.
//  //
//  // If the last strategy throws an authentication failure, then
//  // a `401 Not Authenticated` is thrown.
//  var chainedHandler = auth.authenticate(
//  ['basic','facebook'],
//  authOptions
//  );
//
//  // Apply angel_auth-specific configuration.
//  await app.configure(auth.configureServer);
//
//
//
//
//  app.post("/register", (req, res) async {
//    req.parseBody();
////    print(req.bodyAsMap);
////    print("Body ta mere la pute de merde de ses mort: ${req.bodyAsMap}");
//    var body = await parseBody(req);
//    await res.serialize({"res": "shut leila"});
//  });
}
