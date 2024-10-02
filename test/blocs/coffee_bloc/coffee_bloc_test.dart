import 'package:bloc_test/bloc_test.dart';
import 'package:coffee/blocs/coffee_bloc/coffee_bloc.dart';
import 'package:coffee/blocs/coffee_bloc/coffee_event.dart';
import 'package:coffee/blocs/coffee_bloc/coffee_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee/models/coffee.dart';
import 'package:coffee/services/coffee_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coffee_bloc_test.mocks.dart';

@GenerateMocks([CoffeeService])
void main() {
  late CoffeeBloc coffeeBloc;
  late MockCoffeeService mockCoffeeService;

  setUp(() {
    mockCoffeeService = MockCoffeeService();
    coffeeBloc = CoffeeBloc(mockCoffeeService);
  });

  tearDown(() {
    coffeeBloc.close();
  });

  group('CoffeeBloc', () {
    var coffee = Coffee(
      'coffee.jpg',
      Uint8List.fromList([0, 1, 2]),
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [CoffeeLoading, CoffeeLoaded] when LoadCoffee is added and succeeds',
      setUp: () {
        when(mockCoffeeService.getRandom()).thenAnswer((_) async => coffee);
      },
      build: () => coffeeBloc,
      act: (bloc) => bloc.add(LoadCoffee()),
      expect: () => [
        CoffeeLoading(),
        CoffeeLoaded(coffee),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [CoffeeLoading, CoffeeFailed] when LoadCoffee is added and fails',
      setUp: () {
        when(() => mockCoffeeService.getRandom()).thenThrow(
          Exception('Failed to load coffee'),
        );
      },
      build: () => coffeeBloc,
      act: (bloc) => bloc.add(LoadCoffee()),
      expect: () => [
        CoffeeLoading(),
        CoffeeFailed(),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'ignores LoadCoffee when another loading is in progress',
      setUp: () {
        when(mockCoffeeService.getRandom()).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 3));
          return coffee;
        });
      },
      build: () => coffeeBloc,
      act: (bloc) async {
        bloc.add(LoadCoffee());
        bloc.add(LoadCoffee());
      },
      expect: () => [
        CoffeeLoading(),
      ],
    );
  });
}
