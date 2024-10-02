import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee/models/coffee.dart';
import 'package:coffee/services/coffee_service.dart';

import 'coffee_event.dart';
import 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {

  final CoffeeService _coffeeService;

  bool _inProgress = false;

  CoffeeBloc(this._coffeeService): super(CoffeeLoading()) {

    on<LoadCoffee>(_loadCoffee);
  }

  Future<void> _loadCoffee(LoadCoffee event, Emitter<CoffeeState> emit) async {

    if (_inProgress) {
      return;
    }

    try {

      _inProgress = true;

      emit(CoffeeLoading());

      Coffee coffee = await _coffeeService.getRandom();
      emit(CoffeeLoaded(coffee));
    } catch(e) {
      emit(CoffeeFailed());
    } finally {
      _inProgress = false;
    }
  }
}