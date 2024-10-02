import 'package:coffee/models/coffee.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteCoffeeState  extends Equatable {}

class FavoriteCoffeesLoading extends FavoriteCoffeeState {

  @override
  List<Object?> get props => [];
}

class FavoriteCoffeesLoaded extends FavoriteCoffeeState {

  final List<Coffee> coffees;

  FavoriteCoffeesLoaded(this.coffees);

  @override
  List<Object?> get props => coffees;
}

class FavoriteCoffeesEmpty extends FavoriteCoffeeState {
  @override
  List<Object?> get props => [];
}

class FavoriteCoffeesError extends FavoriteCoffeeState {
  @override
  List<Object?> get props => [];
}