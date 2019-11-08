library instatube_service.src.interface;

import 'dart:async';

import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:instatube_service/src/infrastructure/mongo_service_app.dart';
import 'package:instatube_service/src/interface/rest_service.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'graphql.dart' as graphql;

/// Put your app routes here!
///
/// See the wiki for information about routing, requests, and responses:
/// * https://github.com/angel-dart/angel/wiki/Basic-Routing
/// * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    app.fallback(authMiddleware);

//    await app.configure(AuthService().configureServer);
    // Typically, you want to mount controllers first, after any global middleware.
    // await app.configure(services.configureServer);

    // Mount our GraphQL routes as well.
    await app.configure(graphql.configureServer);
    await app.configure(RestService(fileSystem).configureServer);

    // Render `views/hello.jl` when a user.dart visits the application root.

    app.get('/', (req, res) => res.render('hello'));

    // Mount static server at web in development.
    // The `CachingVirtualDirectory` variant of `VirtualDirectory` also sends `Cache-Control` headers.
    //
    // In production, however, prefer serving static files through NGINX or a
    // similar reverse proxy.
    //
    // Read the following two sources for documentation:
    // * https://medium.com/the-angel-framework/serving-static-files-with-the-angel-framework-2ddc7a2b84ae
    // * https://github.com/angel-dart/static
//    if (!app.environment.isProduction) {
//      var vDir = VirtualDirectory(
//        app,
//        fileSystem,
//        source: fileSystem.directory('web'),
//      );
//      app.fallback(vDir.handleRequest);
//    }

    // Throw a 404 if no route matched the request.
    app.fallback((req, res) => throw AngelHttpException.notFound());

    // Set our application up to handle different errors.
    //
    // Read the following for documentation:
    // * https://github.com/angel-dart/angel/wiki/Error-Handling

    var oldErrorHandler = app.errorHandler;
    app.errorHandler = (e, req, res) async {
      if (req.accepts('text/html', strict: true)) {
        if (e.statusCode == 404 && req.accepts('text/html', strict: true)) {
          await res.render('error', {'message': 'No file exists at ${req.uri}.'});
        } else {
          await res.render('error', {'message': e.message});
        }
      } else {
        return await oldErrorHandler(e, req, res);
      }
    };
  };
}

FutureOr<dynamic> authMiddleware(RequestContext req, res) async {
  var authHeader = req.headers.value('authorization');
  if (authHeader != null) {
    var listAuthHeader = authHeader.split(' ');

    if (listAuthHeader.length == 2) {
      var token = listAuthHeader[1];
      var jwtKey = req.app.configuration['jwt_secret'] as String;

      try {
        final JwtClaim decClaimSet = verifyJwtHS256Signature(token, jwtKey);
        decClaimSet.validate();

        var userId = decClaimSet.subject;
        var userMongoService = mongoServiceApp(req.app, "users");
        var userMap = await userMongoService.findOne({"id": userId}) as Map;
        User user = UserSerializer.fromMap(userMap);
        req.container.registerSingleton(user);
//        req.session['user'] = user;
      } catch (e) {
//        throw AngelHttpException.notAuthenticated(message: "401 Wrong token");
      }
    }
  }

  return true;
}
