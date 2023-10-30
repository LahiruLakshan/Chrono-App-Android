import 'dart:io';

import 'package:flutter/cupertino.dart';

class FoodModel {
  File? _foodImage = File("");

  FoodModel();


  File get foodImage => _foodImage!;

  set foodImage(File value) {
    _foodImage = value;
  }
}
