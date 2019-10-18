import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/infrastructure/graphql/user.dart';

import 'todo.dart';

/// Creates a GraphQL schema that manages an in-memory store of
/// Todo items.
GraphQLSchema createSchema(Angel app) {
  var queryType = objectType(
    'Query',
    fields: [
      ...todoQueryFields(app),
      ...userQueryFields(app),
    ],
  );

  var mutationType = objectType(
    'Mutation',
    fields: [
      ...todoMutationFields(app),
      ...userMutationFields(app),
    ],
  );

  return graphQLSchema(
    queryType: queryType,
    mutationType: mutationType,
  );
}
