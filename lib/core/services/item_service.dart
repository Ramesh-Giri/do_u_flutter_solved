import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:iremember/core/models/item.dart';
import 'package:iremember/core/services/api.dart';

import '../../locator.dart';

class ItemService {
  API _api = locator<API>();

  Future<void> addItem(Item item, File imageFile) {
    return _api.saveItem(item, imageFile);
  }

  Future<DataSnapshot> getItems() {
    return _api.getAllItems();
  }
}
