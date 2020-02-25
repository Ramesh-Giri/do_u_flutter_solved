import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:iremember/core/models/item.dart';
import 'package:iremember/core/services/item_service.dart';
import 'package:iremember/locator.dart';
import '../enums.dart';
import 'base_model.dart';

class ItemModel extends BaseModel {
  final ItemService _itemService = locator.get<ItemService>();
  DataSnapshot snapshot;
  List<MapEntry> itemList = [];

  Future<void> addItem(Item item, File imageFile) async {
    try {
      setState(ViewState.Busy);
      errorMessage = "";
      await _itemService.addItem(item, imageFile);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future<void> getItems() async {
    try {
      setState(ViewState.Busy);
      errorMessage = "";
      snapshot = await _itemService.getItems();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(ViewState.Idle);
    }
  }

  List<MapEntry> allItems() {
    itemList = snapshot.value.entries.toList();
    return itemList;
  }
}
