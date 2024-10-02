import 'package:flutter/foundation.dart';

class Coffee implements Comparable<Coffee> {

  final String url;

  final Uint8List bytes;

  Coffee(this.url, this.bytes);

  @override
  int compareTo(Coffee other) {
    return url.compareTo(other.url);
  }
}