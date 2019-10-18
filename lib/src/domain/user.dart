import 'package:angel_serialize/angel_serialize.dart';
import 'package:graphql_schema/graphql_schema.dart';

part "user.g.dart";

@graphQLClass
@serializable
abstract class _User extends Model {
  String get username;
  String get email;
  String get password;
}
