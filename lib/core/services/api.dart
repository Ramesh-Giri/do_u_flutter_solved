import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iremember/core/models/item.dart';
import 'package:path/path.dart' as Path;

class API {
  
  Future<DataSnapshot> getAllItems() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('items');

    return databaseReference.once();
  }

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('items');

  Future<void> saveItem(Item item, File imageFile) async {
    if (imageFile != null) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('itemImages/${Path.basename(imageFile.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;

      storageReference.getDownloadURL().then((fileURL) {
        item.imageUrl = fileURL;
        databaseReference.push().set(item.toJson());
      });
    } else {
      item.imageUrl = "";
      databaseReference.push().set(item.toJson());
    }
  }
}
