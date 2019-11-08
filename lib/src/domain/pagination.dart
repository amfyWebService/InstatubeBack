import 'dart:convert';

import 'package:graphql_schema/graphql_schema.dart';

GraphQLObjectType edgeGraphQLType<T, Serialized>(GraphQLType<T, Serialized> itemType) {
  return objectType('Edge',
      description: "Generic edge to allow cursors",
      isInterface: false,
      interfaces: [],
      fields: [field('node', itemType), field('cursor', graphQLInt)]);
}

final pageInfoGraphQLType =
    objectType('PageInfo', description: "Information about current page", isInterface: false, interfaces: [], fields: [
  field('startCursor', graphQLString),
  field('endCursor', graphQLString),
  field('hasNextPage', graphQLBoolean),
]);

GraphQLObjectType pageGraphQLType<T, Serialized>(GraphQLType<T, Serialized> itemType) {
  return objectType('Page', description: "Page", isInterface: false, interfaces: [], fields: [
    field('totalCount', graphQLInt),
    field('edges', listOf(edgeGraphQLType(itemType))),
    field('pageInfo', pageInfoGraphQLType)
  ]);
}

String convertNodeToCursor(Map node) {
  return bota(node['id'].toString());
}

String bota(String input) {
  var bytes = utf8.encode(input);
  return base64.encode(bytes);
}

String convertCursorToNodeId(String cursor) {
  var bytes = base64.decode(cursor);
  return utf8.decode(bytes);
}

String atob(String input) {
  var bytes = base64.decode(input);
  return utf8.decode(bytes);
}

//final GraphQLObjectType userTokenGraphQLType = objectType('User', isInterface: false, interfaces: [], fields: [
//  field('token', graphQLString),
//  field('user', userGraphQLType),
//]);

//export function Edge(itemType: any) {
//return new graphql.GraphQLObjectType({
//name: "Edge",
//description: "Generic edge to allow cursors",
//fields: () => ({
//node: { type: itemType },
//cursor: { type: graphql.GraphQLString }
//})
//});
//}
//
//export const PageInfo = new graphql.GraphQLObjectType({
//  name: "PageInfo",
//  description: "Information about current page",
//  fields: () => ({
//    startCursor: { type: graphql.GraphQLString },
//    endCursor: { type: graphql.GraphQLString },
//    hasNextPage: { type: graphql.GraphQLBoolean }
//  })
//});
//
//export function Page(itemType: any) {
//return new graphql.GraphQLObjectType({
//name: "Page",
//description: "Page",
//fields: () => ({
//totalCount: { type: graphql.GraphQLInt },
//edges: { type: new graphql.GraphQLList(Edge(itemType)) },
//pageInfo: { type: PageInfo }
//})
//});
//}
//
