import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:coffee/models/coffee.dart';
import 'package:http/http.dart' as http;

class CoffeeService {

  final String url;

  final int bufferSize;

  final Queue<Coffee> buffer = Queue();

  final http.Client client;

  CoffeeService(this.url, this.bufferSize, this.client);

  Future<Coffee> getRandom() async {

    try {

      if (buffer.isEmpty) {
        await _refillBuffer();
      } else {
        _refillBuffer();
      }

      return buffer.removeFirst();
    } catch(e) {
      throw Exception("Failed to fetch random coffee");
    }
  }

  Future<void> _refillBuffer() async {

    List<Future<Coffee>> futures = [];

    for (int i = buffer.length; i < bufferSize; i++) {
      futures.add(_fetchImage());
    }

    List<Coffee> coffees = await Future.wait(futures);

    for (var coffee in coffees) {
      buffer.add(coffee);
    }
  }

  Future<Coffee> _fetchImage() async {

    try {
      http.Response response = await client.get(Uri.parse(url));

      String fileUrl = jsonDecode(response.body)["file"];

      http.Response imageResponse = await client.get(Uri.parse(fileUrl));
      return Coffee(fileUrl, imageResponse.bodyBytes);
    } catch(e) {
      rethrow;
    }
  }
}