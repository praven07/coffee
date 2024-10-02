import 'package:coffee/blocs/coffee_bloc/coffee_bloc.dart';
import 'package:coffee/blocs/favorite_coffee_bloc/favorite_coffee_bloc.dart';
import 'package:coffee/core/consts.dart';
import 'package:coffee/services/coffee_service.dart';
import 'package:coffee/services/favorite_coffee_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final GetIt locator = GetIt.instance;

void setup() {
  locator.registerSingleton<CoffeeService>(
    CoffeeService(coffeeImageUrl, bufferSize, http.Client()),
  );

  locator.registerSingleton<FavoriteCoffeeService>(
    FavoriteCoffeeService(
      Hive.box(favoriteBoxLocation),
    ),
  );

  locator.registerSingleton<CoffeeBloc>(
    CoffeeBloc(
      locator.get<CoffeeService>(),
    ),
  );

  locator.registerSingleton<FavoriteCoffeeBloc>(
    FavoriteCoffeeBloc(
      locator.get<FavoriteCoffeeService>(),
    ),
  );
}
