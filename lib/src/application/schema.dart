import 'package:angel_framework/angel_framework.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/application/user_schema.dart';
import 'package:instatube_service/src/application/video_schema.dart';

GraphQLSchema createSchema(Angel app) {
  var userSchema = UserSchema(app);
  var videoSchema = VideoSchema(app);

  var queryType = objectType(
    'Query',
    fields: [...userSchema.queryFields(), ...videoSchema.queryFields()],
  );

  var mutationType = objectType(
    'Mutation',
    fields: [...userSchema.mutationFields(), ...videoSchema.mutationFields()],
  );

  return graphQLSchema(
    queryType: queryType,
    mutationType: mutationType,
  );
}
