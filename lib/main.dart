import 'dart:io';

import 'package:coffee/blocs/coffee_bloc/coffee_bloc.dart';
import 'package:coffee/coffee_app.dart';
import 'package:coffee/core/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'blocs/favorite_coffee_bloc/favorite_coffee_bloc.dart';
import 'core/locator.dart' as locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  if (!Hive.isBoxOpen(favoriteBoxLocation)) {
    await Hive.openBox<Uint8List>(favoriteBoxLocation);
  }

  locator.setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CoffeeBloc>(
          create: (context) => GetIt.instance.get<CoffeeBloc>(),
        ),
        BlocProvider<FavoriteCoffeeBloc>(
          create: (context) => GetIt.instance.get<FavoriteCoffeeBloc>(),
        ),
      ],
      child: const CoffeeApp(),
    ),
  );
}
