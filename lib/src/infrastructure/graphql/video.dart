import 'package:angel_framework/angel_framework.dart';
import 'package:angel_graphql/angel_graphql.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/domain/video.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:instatube_service/src/infrastructure/noConnectionFound.dart';


MongoService _mongoService(Angel app) {
  const key = 'mongoDb';

  // If there is already an existing singleton, return it.
  if (!app.container.hasNamed(key)) {
    throw NoConnectionFound().reason;
  }
  var db = app.container.findByName<Db>(key);
  return MongoService(db.collection("videos"));
}

Iterable<GraphQLObjectField> videoQueryFields(Angel app) {
  var service = _mongoService(app);

  // Here, we use special resolvers to read data from our store.
  return [
    field(
      'videos',
      listOf(videoGraphQLType),
      resolve: resolveViaServiceIndex(service),
    ),
    field(
      'video',
      videoGraphQLType,
      resolve: resolveViaServiceRead(service),
      inputs: [
        GraphQLFieldInput('id', graphQLString.nonNullable()),
      ],
    ),
  ];
}

Iterable<GraphQLObjectField> videoMutationFields(Angel app) {
  var service = _mongoService(app);
  var inputType = videoGraphQLType.toInputObject('VideoInput');

  // This time, we use resolvers to modify the data in the store.
  return [
    field(
      'createVideo',
      videoGraphQLType,
      resolve: resolveViaServiceCreate(service),
      inputs: [
        GraphQLFieldInput('data', inputType.nonNullable()),
      ],
    ),
    field(
      'updateVideo',
      videoGraphQLType,
      resolve: resolveViaServiceModify(service),
      inputs: [
        GraphQLFieldInput('id', graphQLString.nonNullable()),
        GraphQLFieldInput('data', inputType.nonNullable()),
      ],
    )
  ];
}
