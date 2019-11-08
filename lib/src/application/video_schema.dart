import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/src/core/server.dart';
import 'package:angel_graphql/angel_graphql.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/application/base_schema.dart';
import 'package:instatube_service/src/domain/auth_service.dart';
import 'package:instatube_service/src/domain/pagination.dart';
import 'package:instatube_service/src/domain/shared_service.dart';
import 'package:instatube_service/src/domain/video.dart';
import 'package:instatube_service/src/domain/video_service.dart';
import 'package:instatube_service/src/infrastructure/mongo_service_app.dart';

class VideoSchema extends BaseSchema {
  final modelInputType = videoGraphQLType.toInputObject('VideoInput');

  VideoSchema(Angel app) : super(app, mongoServiceApp(app, "videos"));

  @override
  mutationFields() {
    // This time, we use resolvers to modify the data in the store.
    return [
      field(
        'createVideo',
        videoGraphQLType,
        resolve: resolveAuth(resolveCreateVideo(service)),
        inputs: [
          GraphQLFieldInput('data', modelInputType.nonNullable()),
        ],
      ),
      field(
        'updateVideo',
        videoGraphQLType,
        resolve: resolveViaServiceModify(service),
        inputs: [
          GraphQLFieldInput('id', graphQLString.nonNullable()),
          GraphQLFieldInput('data', modelInputType.nonNullable()),
        ],
      )
    ];
  }

  @override
  queryFields() {
    return [
      field('videos', pageGraphQLType(videoGraphQLType), resolve: resolvePagination(service), inputs: [
        GraphQLFieldInput('first', graphQLInt),
        GraphQLFieldInput('last', graphQLInt),
        GraphQLFieldInput('cursor', graphQLInt),
//        GraphQLFieldInput('title', graphQLString),
      ]),
      field(
        'video',
        videoGraphQLType,
        resolve: resolveViaServiceRead(service),
        inputs: [
          GraphQLFieldInput('id', graphQLString.nonNullable()),
        ],
      ),
      field('videosByUserId', listOf(videoGraphQLType), resolve: resolveViaServiceFindAllBy(service), inputs: [
        GraphQLFieldInput('user_id', graphQLString),
      ]),
    ];
  }
}
