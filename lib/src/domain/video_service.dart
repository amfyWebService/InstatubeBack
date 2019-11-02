import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:path/path.dart' as path;

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
GraphQLFieldResolver<Value, Serialized> resolveCreateVideo<Value, Serialized>(Service<dynamic, Value> service) {
  return (_, arguments) async {
    RequestContext req = arguments['__requestctx'] as RequestContext;
    var data = arguments['data'];

    var user = req.container.make<User>();

    var file = getFile(user, data['filename'] as String, req.app);
    if (!file.existsSync()) throw AngelHttpException.badRequest(message: "file doesn't exist");

    data['user_id'] = user.id;

    return service.create(data as Value);
  };
}

File getFile(User user, String filename, Angel app){
  return File(path.join(
            app.configuration['path_video'] as String, user.id, filename));
}
