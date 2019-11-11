import 'dart:math';

import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';

Map<String, dynamic> _fetchRequestInfo(Map<String, dynamic> arguments) {
  return <String, dynamic>{
    '__requestctx': arguments.remove('__requestctx'),
    '__responsectx': arguments.remove('__responsectx'),
  };
}

GraphQLFieldResolver<List<Value>, Serialized> resolveViaServiceFindAllBy<Value, Serialized>(
    Service<dynamic, Value> service) {
  return (_, arguments) async {
    var _requestInfo = _fetchRequestInfo(arguments);
    var params = {'query': arguments, 'provider': Providers.graphQL}..addAll(_requestInfo);
    return service.index(params);
  };
}

GraphQLFieldResolver<Map, Serialized> resolvePagination<Value, Serialized>(Service<dynamic, Value> service) {
  return (_, arguments) async {
    var _requestInfo = _fetchRequestInfo(arguments);

    // Inputs
    int limit = (arguments['first'] ?? arguments['last'] ?? 10) as int;
    final bool reversed = arguments['last'] != null;
//    var cursor = arguments['cursor'];
    int offset = (arguments['cursor'] ?? arguments['after'] ?? 0) as int;

    // Db query
    var params = {'query': arguments['where'], 'provider': Providers.graphQL}..addAll(_requestInfo);
    List<dynamic> items = await service.index(params);
    // Post treatment
    int totalCount = items.length;
    if (limit < 0) limit = 0;

    if (reversed) {
      items = items.reversed.toList();
    }

    var endIndex = max(min(offset + limit, totalCount - 1), 0);
    var currentCursor = 0;
    items = items.getRange(offset, endIndex).map((item) => {"node": item, "cursor": currentCursor++}).toList();
//    print("offset $offset, limit $limit, count $totalCount, endIndex $endIndex");
    bool hasNextPage = (totalCount != 0 ?? endIndex < totalCount);
    // Response
    return {
      "totalCount": totalCount,
      "edges": items,
      "pageInfo": {"hasNextPage": hasNextPage}
    };
  };
}
