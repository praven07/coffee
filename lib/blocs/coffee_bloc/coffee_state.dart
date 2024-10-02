import 'package:coffee/models/coffee.dart';
import 'package:equatable/equatable.dart';

abstract class CoffeeState extends Equatable {}

class CoffeeLoading extends CoffeeState {
  @override
  List<Object?> get props => [];
}

class CoffeeLoaded extends CoffeeState {

  final Coffee coffee;

  CoffeeLoaded(this.coffee);

  @override
  List<Object?> get props => [coffee.url];
}

class CoffeeFailed extends CoffeeState {
  @override
  List<Object?> get props => [];
}