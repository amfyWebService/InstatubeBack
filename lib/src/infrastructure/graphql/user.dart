import 'package:angel_framework/angel_framework.dart';
import 'package:angel_graphql/angel_graphql.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/domain/user.dart';

/// Find or create an in-memory Todo store.
MapService _getService(Angel app) {
  const key = 'userService';

  // If there is already an existing singleton, return it.
  if (app.container.hasNamed(key)) {
    return app.container.findByName<MapService>(key);
  }

  // Create an in-memory service. We will use this
  // as the backend to store Todo objects, serialized to Maps.
  var mapService = MapService();

  // Register this service as a named singleton in the app container,
  // so that we do not inadvertently create another instance.
  app.container.registerNamedSingleton(key, mapService);

  return mapService;
}

/// Returns fields to be inserted into the query type.
Iterable<GraphQLObjectField> userQueryFields(Angel app) {
  var service = _getService(app);

  // Here, we use special resolvers to read data from our store.
  return [
    field(
      'users',
      listOf(userGraphQLType),
      resolve: resolveViaServiceIndex(service),
    ),
    field(
      'user',
      userGraphQLType,
      resolve: resolveViaServiceRead(service),
      inputs: [
        GraphQLFieldInput('id', graphQLString.nonNullable()),
      ],
    ),
  ];
}

/// Returns fields to be inserted into the query type.
Iterable<GraphQLObjectField> userMutationFields(Angel app) {
  var service = _getService(app);
  var inputType = userGraphQLType.toInputObject('UserInput');

  // This time, we use resolvers to modify the data in the store.
  return [
    field(
      'createUser',
      userGraphQLType,
      resolve: resolveViaServiceCreate(service),
      inputs: [
        GraphQLFieldInput('data', inputType.nonNullable()),
      ],
    ),
    field(
      'modifyUser',
      userGraphQLType,
      resolve: resolveViaServiceModify(service),
      inputs: [
        GraphQLFieldInput('id', graphQLString.nonNullable()),
        GraphQLFieldInput('data', inputType.nonNullable()),
      ],
    ),
  ];
}
