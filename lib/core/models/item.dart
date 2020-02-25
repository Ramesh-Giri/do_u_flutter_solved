import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

class Item {
  String key;
  String title;
  String description;
  String imageUrl;

  Item({this.title, this.imageUrl, this.description});

  Item.fromSnapShot(DataSnapshot snapshot)
      : this.key = snapshot.key,
        this.title = snapshot.value["title"],
        this.description = snapshot.value["description"],
        this.imageUrl = snapshot.value["image"];

  toJson() {
    return {
      "title": title,
      "description": description,
      "image": imageUrl,
    };
  }
}
