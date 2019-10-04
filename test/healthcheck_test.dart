import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /healthcheck returns 200 Ok", () async {
    expectResponse(await harness.agent.get("/healthcheck"), 200, body: "Ok");
  });
}
