import 'package:bloc_test/bloc_test.dart';
import 'package:coffee/blocs/favorite_coffee_bloc/favorite_coffee_bloc.dart';
import 'package:coffee/blocs/favorite_coffee_bloc/favorite_coffee_event.dart';
import 'package:coffee/blocs/favorite_coffee_bloc/favorite_coffee_state.dart';
import 'package:coffee/services/favorite_coffee_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffee/models/coffee.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'favorite_coffee_bloc_test.mocks.dart';


@GenerateMocks([FavoriteCoffeeService])
void main() {
  late FavoriteCoffeeBloc favoriteCoffeeBloc;
  late MockFavoriteCoffeeService mockFavoriteCoffeeService;

  setUp(() {
    mockFavoriteCoffeeService = MockFavoriteCoffeeService();
    when(mockFavoriteCoffeeService.length()).thenReturn(1);
    favoriteCoffeeBloc = FavoriteCoffeeBloc(mockFavoriteCoffeeService);
  });

  tearDown(() {
    favoriteCoffeeBloc.close();
  });

  group('FavoriteCoffeeBloc', () {

    var coffee = Coffee(
      'coffee.jpg',
      Uint8List.fromList([0, 1, 2]),
    );

    blocTest<FavoriteCoffeeBloc, FavoriteCoffeeState>(
      'emits [FavoriteCoffeesLoading, FavoriteCoffeesLoaded] when LoadFavoriteCoffees is added and coffees are available',
      setUp: () {
        when(mockFavoriteCoffeeService.getAll()).thenReturn([coffee]);
        when(mockFavoriteCoffeeService.length()).thenReturn(1);
      },
      build: () => favoriteCoffeeBloc,
      act: (bloc) => bloc.add(LoadFavoriteCoffees()),
      expect: () => [
        FavoriteCoffeesLoading(),
        FavoriteCoffeesLoaded([coffee])
      ],
      verify: (_) {
        verify(mockFavoriteCoffeeService.getAll()).called(1);
      },
    );

    blocTest<FavoriteCoffeeBloc, FavoriteCoffeeState>(
      'emits [FavoriteCoffeesLoading, FavoriteCoffeesError] when LoadFavoriteCoffees is added and fails',
      setUp: () {
        when(mockFavoriteCoffeeService.getAll()).thenThrow(Exception());
      },
      build: () => favoriteCoffeeBloc,
      act: (bloc) => bloc.add(LoadFavoriteCoffees()),
      expect: () => [
        FavoriteCoffeesLoading(),
        FavoriteCoffeesError()
      ],
      verify: (_) {
        verify(mockFavoriteCoffeeService.getAll()).called(1);
      },
    );

    blocTest<FavoriteCoffeeBloc, FavoriteCoffeeState>(
      'emits [FavoriteCoffeesLoading, FavoriteCoffeesEmpty] when LoadFavoriteCoffees is added and is empty',
      setUp: () {
        when(mockFavoriteCoffeeService.getAll()).thenReturn([]);
      },
      build: () => favoriteCoffeeBloc,
      act: (bloc) => bloc.add(LoadFavoriteCoffees()),
      expect: () => [
        FavoriteCoffeesLoading(),
        FavoriteCoffeesEmpty()
      ],
      verify: (_) {
        verify(mockFavoriteCoffeeService.getAll()).called(1);
      },
    );

    blocTest<FavoriteCoffeeBloc, FavoriteCoffeeState>(
      'updates count and adds coffee when AddFavoriteCoffee is added',
      build: () => favoriteCoffeeBloc,
      setUp: () {
        when(mockFavoriteCoffeeService.length()).thenReturn(3);
      },
      act: (bloc) => bloc.add(AddFavoriteCoffee(coffee)),
      verify: (_) {
        verify(mockFavoriteCoffeeService.add(coffee)).called(1);
        expect(favoriteCoffeeBloc.length.value, 3);
      },
    );
  });
}
