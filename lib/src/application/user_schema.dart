import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/src/core/server.dart';
import 'package:angel_graphql/angel_graphql.dart';
import 'package:graphql_schema/graphql_schema.dart';
import 'package:instatube_service/src/application/base_schema.dart';
import 'package:instatube_service/src/domain/auth_service.dart' as auth;
import 'package:instatube_service/src/domain/user.dart';
import 'package:instatube_service/src/domain/user_service.dart';
import 'package:instatube_service/src/infrastructure/mongo_service_app.dart';

class UserSchema extends BaseSchema {
  final userInputType = userGraphQLType.toInputObject('UserInput');

  UserSchema(Angel app) : super(app, mongoServiceApp(app, "users"));

  @override
  mutationFields() {
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

  @override
  queryFields() {
    return [
      field(
        'users',
        listOf(userGraphQLType),
        resolve: auth.resolveAuth(resolveViaServiceIndex(service)),
      ),
      field(
        'user',
        userGraphQLType,
        resolve: auth.resolveAuth(resolveViaServiceRead(service)),
        inputs: [
          GraphQLFieldInput('id', graphQLString.nonNullable()),
        ],
      ),
      field(
        'me',
        userGraphQLType,
        resolve: auth.resolveAuth(resolveViaServiceUserMe(service)),
      ),
    ];
  }
}
