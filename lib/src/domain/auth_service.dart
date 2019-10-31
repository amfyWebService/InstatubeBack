import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/infrastructure/mongo_service_app.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

Map<String, dynamic> _fetchRequestInfo(Map<String, dynamic> arguments) {
  return <String, dynamic>{
    '__requestctx': arguments.remove('__requestctx'),
    '__responsectx': arguments.remove('__responsectx'),
  };
}

Map<String, dynamic> _getQuery(Map<String, dynamic> arguments) {
  var f = Map<String, dynamic>.from(arguments)..remove('id')..remove('data');
  return f.isEmpty ? null : {};
}

/// A GraphQL resolver that `creates` a single value in an Angel service.
///
/// This resolver should be used on a field with at least the following input:
/// * `data`: a [GraphQLObjectType] corresponding to the format of `data` to be passed to `create`
///
/// The arguments passed to the resolver will be forwarded to the service, and the
/// service will receive [Providers.graphql].
GraphQLFieldResolver<dynamic, Serialized> resolveAuth<Value, Serialized>(GraphQLFieldResolver<dynamic, Serialized> resolver) {
  return (_, arguments) async {
    RequestContext req = arguments['__requestctx'] as RequestContext;

    var authHeader = req.headers.value('authorization');
    if (authHeader == null) {
      throw AngelHttpException.notAuthenticated();
    }

    var listAuthHeader = authHeader.split(' ');

    if (listAuthHeader.length != 2) {
      throw AngelHttpException.notAuthenticated();
    }

    var token = listAuthHeader[1];
    var jwtKey = req.app.configuration['jwt_secret'] as String;

    try {
      final JwtClaim decClaimSet = verifyJwtHS256Signature(token, jwtKey);
      decClaimSet.validate();

      var userId = decClaimSet.subject;
      var userMongoService = mongoServiceApp(req.app, "users");
      var user = await userMongoService.findOne({"id": userId});
      req.session['user'] = user;

      return resolver(_, arguments);
    } catch (e) {
      throw AngelHttpException.notAuthenticated(message: "401 Wrong token");
    }
  };
}
