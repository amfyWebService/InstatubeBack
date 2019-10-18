// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends _User {
  User(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.username,
      this.email,
      this.password});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  final String username;

  @override
  final String email;

  @override
  final String password;

  User copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String username,
      String email,
      String password}) {
    return User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, username, email, password]);
  }

  @override
  String toString() {
    return "User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, username=$username, email=$email, password=$password)";
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const UserSerializer userSerializer = UserSerializer();

class UserEncoder extends Converter<User, Map> {
  const UserEncoder();

  @override
  Map convert(User model) => UserSerializer.toMap(model);
}

class UserDecoder extends Converter<Map, User> {
  const UserDecoder();

  @override
  User convert(Map map) => UserSerializer.fromMap(map);
}

class UserSerializer extends Codec<User, Map> {
  const UserSerializer();

  @override
  get encoder => const UserEncoder();
  @override
  get decoder => const UserDecoder();
  static User fromMap(Map map) {
    return User(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        username: map['username'] as String,
        email: map['email'] as String,
        password: map['password'] as String);
  }

  static Map<String, dynamic> toMap(_User model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'username': model.username,
      'email': model.email,
      'password': model.password
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    username,
    email,
    password
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String username = 'username';

  static const String email = 'email';

  static const String password = 'password';
}

// **************************************************************************
// _GraphQLGenerator
// **************************************************************************

/// Auto-generated from [User].
final GraphQLObjectType userGraphQLType =
    objectType('User', isInterface: false, interfaces: [], fields: [
  field('id', graphQLString),
  field('created_at', graphQLDate),
  field('updated_at', graphQLDate),
  field('username', graphQLString),
  field('email', graphQLString),
  field('password', graphQLString),
  field('idAsInt', graphQLInt)
]);
