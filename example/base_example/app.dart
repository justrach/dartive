import 'dart:async';

import 'package:dartive/dartive.dart';
import 'dart:isolate';

// going to try the dart isolate to spin up a new process for a "heavy computation"
void findPrimes(SendPort sendPort) {
  int N = 100000000; // Consider this as a big number
  List<bool> isPrime = List.filled(N + 1, true);
  isPrime[0] = false;
  isPrime[1] = false;

  for (int p = 2; p * p <= N; p++) {
    if (isPrime[p]) {
      for (int i = p * p; i <= N; i += p) {
        isPrime[i] = false;
      }
    }
  }

  List<int> primes = [];
  for (int i = 0; i <= N; i++) {
    if (isPrime[i]) {
      primes.add(i);
    }
  }

  // Send the primes back to the main isolate.
  sendPort.send(primes);
}

Future<List> findPrimes2() async {
  int N = 100000000; // Consider this as a big number
  List<bool> isPrime = List.filled(N + 1, true);
  isPrime[0] = false;
  isPrime[1] = false;

  for (int p = 2; p * p <= N; p++) {
    if (isPrime[p]) {
      for (int i = p * p; i <= N; i += p) {
        isPrime[i] = false;
      }
    }
  }

  List<int> primes = [];
  for (int i = 0; i <= N; i++) {
    if (isPrime[i]) {
      primes.add(i);
    }
  }
  return primes;

  // Print the primes.
}
Future<Isolate> spawnIsolate(FutureOr<void> Function(SendPort sendPort) entryPoint) async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(entryPoint, receivePort.sendPort);
  return Future.value(isolate);
}
void main(List<String> arguments) async {
  Dartive.get('/heavy-computation', (Dartive api) async {
    // Create a receive port to receive messages from the isolate.
    ReceivePort receivePort = ReceivePort();

    // Start the isolate. Provide the send port of the receive port to the isolate
    // so the isolate can send messages back.
    await Isolate.spawn(findPrimes, receivePort.sendPort);
    List<int> primes = await receivePort.first;
    print(primes);
    // Wait for the result from the isolate.

    // Return the result.
    return {"primes"};
  });
  Dartive.get('/', () async {
    print("This is running");

    return {"Hello World "};
  });

  Dartive.post('/test', (Dartive api) async {
    var body = api.request;
    return body;
  });

  Dartive.post('/newpage', (Dartive api) async {
    var body = api.request;
    body.json();
    // add another field to body
    List<String> items = body.split('');
    items.add("newitem");
    return items;
  });

  Dartive.delete('/delete', () {
    return {'deleted item'};
  });
  Dartive.get('/delete', () {
    return {'get deleted  item'};
  });

  Dartive.get('/busInformation', () {
    return {
      "Id": "5E",
      "Name": "511 Emergency",
      "ShortName": "511 Emergency",
      "SiriOperatorRef": null,
      "TimeZone": "America/Vancouver",
      "DefaultLanguage": "en",
      "ContactTelephoneNumber": null,
      "WebSite": null,
      "PrimaryMode": "other",
      "PrivateCode": "5E",
      "Monitored": false,
      "OtherModes": ""
    };
  });

  // comment
  await Dartive.listen(host: '0.0.0.0', port: 8000);
}
