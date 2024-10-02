import 'package:coffee/models/coffee.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FavoriteCoffeeService {

  late final Box<Uint8List> box;

  FavoriteCoffeeService(this.box);

  void add(Coffee coffee) {
    box.put(coffee.url, coffee.bytes);
  }

  List<Coffee> getAll() {

    List<Coffee> coffees = [];

    box.toMap().forEach((key, value) {
      coffees.add(Coffee(key, value));
    });

    return coffees;
  }

  int length() {
    return box.length;
  }
}