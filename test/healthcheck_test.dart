import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /healthcheck returns 200 Ok", () async {
    expectResponse(await harness.agent.get("/healthcheck"), 200, body: "Ok");
  });
   test("GET /ping returns 200 ping ta mere", () async {
    expectResponse(await harness.agent.get("/ping"), 200, body: "ping ta mere");
  });
}
