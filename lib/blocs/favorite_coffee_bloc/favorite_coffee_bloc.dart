import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coffee/models/coffee.dart';
import 'package:coffee/services/favorite_coffee_service.dart';
import 'package:rxdart/rxdart.dart';

import 'favorite_coffee_event.dart';
import 'favorite_coffee_state.dart';


class FavoriteCoffeeBloc extends Bloc<FavoriteCoffeeEvent, FavoriteCoffeeState> {

  final FavoriteCoffeeService _favoriteCoffeeService;

  final BehaviorSubject<int> _countSubject = BehaviorSubject.seeded(0);

  FavoriteCoffeeBloc(this._favoriteCoffeeService): super(FavoriteCoffeesLoading()) {

    _countSubject.add(_favoriteCoffeeService.length());

    on<LoadFavoriteCoffees>(_loadFavoriteCoffees);
    on<AddFavoriteCoffee>(_addFavoriteCoffee);
  }

  ValueStream<int> get length => _countSubject.stream;

  Future<void> _loadFavoriteCoffees(LoadFavoriteCoffees event, Emitter<FavoriteCoffeeState> emit) async {

    try {

      emit(FavoriteCoffeesLoading());

      List<Coffee> coffees = _favoriteCoffeeService.getAll();

      _updateItemCount();

      if (coffees.isEmpty) {
        emit(FavoriteCoffeesEmpty());
      } else {
        emit(FavoriteCoffeesLoaded(coffees));
      }
    } catch(e) {
      emit(FavoriteCoffeesError());
    }
  }

  Future<void> _addFavoriteCoffee(AddFavoriteCoffee event, Emitter<FavoriteCoffeeState> emit) async {

    _favoriteCoffeeService.add(event.coffee);
    _updateItemCount();
  }

  void _updateItemCount() {
    _countSubject.add(_favoriteCoffeeService.length());
  }
}