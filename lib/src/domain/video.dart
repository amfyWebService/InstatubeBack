import 'package:angel_serialize/angel_serialize.dart';
import 'package:graphql_schema/graphql_schema.dart';

part "video.g.dart";

@graphQLClass
@serializable
abstract class _Video extends Model {
  String get userId;

  String get title;

  String get description;

  String get filename;
}