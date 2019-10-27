import 'package:angel_framework/angel_framework.dart';
import 'package:angel_graphql/angel_graphql.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:instatube_service/src/domain/user_service.dart';
import 'package:instatube_service/src/infrastructure/noConnectionFound.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Find or create an in-memory Todo store.
MongoService _mongoService(Angel app) {
  const key = 'mongoDb';

  // If there is already an existing singleton, return it.
  if (!app.container.hasNamed(key)) {
    throw NoConnectionFound().reason;
  }
  var db = app.container.findByName<Db>(key);
  return MongoService(db.collection("users"));
}

/// Returns fields to be inserted into the query type.
Iterable<GraphQLObjectField> userQueryFields(Angel app) {
  var service = _mongoService(app);

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
  var service = _mongoService(app);
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
    field('register', userGraphQLType, resolve: resolveViaServiceRegister(service), inputs: [
      GraphQLFieldInput('username', graphQLString.nonNullable()),
      GraphQLFieldInput('password', graphQLString.nonNullable()),
    ]),
    field('login', userTokenGraphQLType, resolve: resolveViaServiceLogin(service), inputs: [
      GraphQLFieldInput('username', graphQLString.nonNullable()),
      GraphQLFieldInput('password', graphQLString.nonNullable()),
    ])
  ];
}
