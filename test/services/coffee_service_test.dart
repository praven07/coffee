import 'package:coffee/models/coffee.dart';
import 'package:coffee/services/coffee_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'coffee_service_test.mocks.dart';


@GenerateMocks([http.Client])
void main() {
  group('CoffeeService Tests', () {

    const int bufferSize = 3;
    const String url = "test_url";

    late MockClient mockClient;
    late CoffeeService coffeeService;

    setUp(() {
      mockClient = MockClient();
      coffeeService = CoffeeService(url, bufferSize, mockClient);
    });

    test('getRandom() should return a Coffee from the buffer', () async {

      when(mockClient.get((Uri.parse(url)))).thenAnswer((_) async {
        return http.Response('{"file": "coffee.jpg"}', 200);
      });

      when(mockClient.get((Uri.parse("coffee.jpg")))).thenAnswer((_) async {
        return http.Response(Uint8List.fromList([0, 1, 2]).toString(), 200);
      });

      final coffee = await coffeeService.getRandom();

      expect(coffee, isA<Coffee>());
    });

    test('getRandom() should throw an exception when failed', () async {

      when(mockClient.get((Uri.parse(url)))).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      expect(coffeeService.getRandom(), throwsException);
    });
  });
}