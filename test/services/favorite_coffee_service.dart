import 'package:coffee/models/coffee.dart';
import 'package:coffee/services/favorite_coffee_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favorite_coffee_service.mocks.dart';


@GenerateMocks([Box])
void main() {
  group('FavoriteCoffeeService Tests', () {

    late MockBox<Uint8List> mockBox;
    late FavoriteCoffeeService favoriteCoffeeService;

    setUp(() {
      mockBox = MockBox<Uint8List>();
      favoriteCoffeeService = FavoriteCoffeeService(mockBox);
    });

    test('add() should add a Coffee to the box', () {

      final coffee = Coffee('coffee.jpg', Uint8List(10));

      favoriteCoffeeService.add(coffee);

      verify(mockBox.put(coffee.url, coffee.bytes)).called(1);
    });

    test('getAll() should return all coffees from the box', () {

      when(mockBox.toMap()).thenReturn({
        'coffee1.jpg': Uint8List(10),
        'coffee2.jpg': Uint8List(20),
      });

      final coffees = favoriteCoffeeService.getAll();

      expect(coffees.length, 2);
      expect(coffees[0].url, 'coffee1.jpg');
      expect(coffees[1].url, 'coffee2.jpg');
    });

    test('length should return the correct number of items in the box', () {

      when(mockBox.length).thenReturn(3);

      final length = favoriteCoffeeService.length;

      expect(length, 3);
    });
  });
}