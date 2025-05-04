import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  int _itemCount = 0;

  int get itemCount => _itemCount;

  get items => null;

  void addItem() {
    _itemCount++;
    notifyListeners();
  }
}
