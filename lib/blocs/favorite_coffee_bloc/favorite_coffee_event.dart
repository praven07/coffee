import 'package:coffee/models/coffee.dart';

abstract class FavoriteCoffeeEvent {}

class LoadFavoriteCoffees extends FavoriteCoffeeEvent {}

class AddFavoriteCoffee extends FavoriteCoffeeEvent {

  final Coffee coffee;

  AddFavoriteCoffee(this.coffee);
}

