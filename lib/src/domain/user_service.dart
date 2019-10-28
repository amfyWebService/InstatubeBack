import 'package:angel_framework/angel_framework.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:graphql_schema/graphql_schema.dart';
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
GraphQLFieldResolver<Value, Serialized> resolveViaServiceRegister<Value, Serialized>(Service<dynamic, Value> service) {
  return (_, arguments) async {
    var _requestInfo = _fetchRequestInfo(arguments);
    var params = {'query': _getQuery(arguments), 'provider': Providers.graphQL}..addAll(_requestInfo);

    String username = arguments['username'] as String;
    String password = arguments['password'] as String;

    try {
      await service.findOne({
        "query": {"username": username}
      });
    } catch (e) {
      String hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());
      return await service.create({"username": username, "password": hashedPassword} as Value, params);
    }

    throw AngelHttpException.conflict(message: "User already exist");
  };
}

/// A GraphQL resolver that `creates` a single value in an Angel service.
///
/// This resolver should be used on a field with at least the following input:
/// * `data`: a [GraphQLObjectType] corresponding to the format of `data` to be passed to `create`
///
/// The arguments passed to the resolver will be forwarded to the service, and the
/// service will receive [Providers.graphql].
GraphQLFieldResolver<Map, Serialized> resolveViaServiceLogin<Value, Serialized>(Service<dynamic, Value> service) {
  return (_, arguments) async {
    String username = arguments['username'] as String;
    String password = arguments['password'] as String;

    var _requestInfo = _fetchRequestInfo(arguments);

    Map user = await service.findOne({
      "query": {"username": username}
    }) as Map;

    if (!DBCrypt().checkpw(password, user['password'] as String)) {
      throw AngelHttpException.forbidden();
    }

    RequestContext req = _requestInfo['__requestctx'] as RequestContext;
    var jwtKey = req.app.configuration['jwt_secret'] as String;

    var claimSet = JwtClaim(subject: user['id'] as String, maxAge: const Duration(days: 7));
    String token = issueJwtHS256(claimSet, jwtKey);

    return {"token": token, "user": user};
  };
}
