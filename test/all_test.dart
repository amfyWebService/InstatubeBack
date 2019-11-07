import 'dart:io';

import 'package:instatube_service/instatube_service.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_container/mirrors.dart';
import 'package:angel_test/angel_test.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// Angel also includes facilities to make testing easier.
//
// `package:angel_test` ships a client that can test
// both plain HTTP and WebSockets.
//
// Tests do not require your server to actually be mounted on a port,
// so they will run faster than they would in other frameworks, where you
// would have to first bind a socket, and then account for network latency.
//
// See the documentation here:
// https://github.com/angel-dart/test
//
// If you are unfamiliar with Dart's advanced testing library, you can read up
// here:
// https://github.com/dart-lang/test
main() async {
  Angel app;
  TestClient client;
  MockService mockService;

  setUp(() async {
    app = Angel(
        environment: AngelEnvironment("TEST"), reflector: MirrorsReflector());
    await app.configure(configureServer);
    client = await connectTo(app);
  });

  tearDown(() async {
    await client.close();
  });

  group(
      'chore tests',
      () => {
            test('index returns 200', () async {
              // Request a resource at the given path.
              var response = await client.get('/');

              // Expect a 200 response.
              expect(response, hasStatus(200));
            }),
            test('graphiql returns 200', () async {
              // Request a resource at the given path.
              var response = await client.get('/graphiql');

              expect(response, hasStatus(200));
            }),
            test('should returns 400 if a request is incorrect', () async {
              // Request a resource at the given path.
              var response = await client
                  .post('/graphql', body: {"query": "incorrect request"});

              expect(response, hasStatus(200));
              expect(response,
                  hasBody('{"errors":[{"message":"400 Bad Request"}]}'));
            }),
          });
  group(
      'authentication tests',
      () => {
            test('should returns 403 if the user is not authenticated',
                () async {
              // when(mockService.findOne()).thenAnswer((_) => Future.value());
              var response = await client.post('/graphql',
                  body: """{"query": "query{users()}"}""",
                  headers: {"Content-Type": "application/json"});

              expect(response, hasStatus(403));
              expect(response,
                  hasBody('{"errors":[{"message":"403 Forbidden"}]}'));
            }),
          });
}

class MockService extends Mock implements Service {}
