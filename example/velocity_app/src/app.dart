import 'package:dartive/dartive.dart';
 
void main(List<String> arguments) async {
  Dartive.get('/', () {
    print("This is running");
 
    return {'Hello World'};
  });
 
  Dartive.post('/test', (Dartive api) async {
    var body = api.request;
 
    return body;
  });
 
  await Dartive.listen(host: '0.0.0.0', port: 8000);
}