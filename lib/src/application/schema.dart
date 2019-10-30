import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/infrastructure/graphql/user.dart';
import 'package:instatube_service/src/infrastructure/graphql/video.dart';
import 'package:instatube_service/src/infrastructure/graphql/video.dart' as prefix0;

GraphQLSchema createSchema(Angel app) {
  var queryType = objectType(
    'Query',
    fields: [
      ...userQueryFields(app),
      ...videoQueryFields(app)
    ],
  );

  var mutationType = objectType(
    'Mutation',
    fields: [
      ...userMutationFields(app),
      ...videoMutationFields(app)
    ],
  );

  return graphQLSchema(
    queryType: queryType,
    mutationType: mutationType,
  );
}
