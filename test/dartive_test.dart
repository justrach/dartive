import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
void main() {
  test('GET / returns correct response', () async {
    var response = await http.get(Uri.parse('http://localhost:8080/'));
    expect(response.statusCode, 200);
    expect(response.body, 'return new');
  });

  test('GET /busInformation returns correct response', () async {
    var response = await http.get(Uri.parse('http://localhost:8080/busInformation'));
    expect(response.statusCode, 200);
    // Replace the following with the actual response body
    expect(response.body, contains('511 Emergency'));
  });

  test('POST /some.json returns correct response', () async {
    var response = await http.post(
      Uri.parse('http://localhost:8080/some.json'),
      body: jsonEncode({
        // Replace this with the actual request body
        'key': 'value',
      }),
    );
    expect(response.statusCode, 200);
    // Replace the following with the actual response body
    expect(response.body, contains('expected value'));
  });
}
