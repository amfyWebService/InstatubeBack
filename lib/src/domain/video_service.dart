import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
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
GraphQLFieldResolver<Value, Serialized> resolveUploadVideo<Value, Serialized>(Service<dynamic, Value> service) {
  return (_, arguments) async {
    RequestContext req = arguments['__requestctx'] as RequestContext;

    try {
      var file = req.uploadedFiles.first;

      var destFile = await File(path.join(req.app.configuration['path_video'] as String, "123456", "taMere.mkv")).create(recursive: true);
      await file.data.pipe(destFile.openWrite());

      return {} as Value;
    } catch (e) {
      throw AngelHttpException.conflict();
    }
  };
}
