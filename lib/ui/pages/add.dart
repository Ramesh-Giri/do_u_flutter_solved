import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iremember/core/enums.dart';
import 'package:iremember/core/models/item.dart';
import 'package:iremember/core/validator.dart';
import 'package:iremember/core/view_models/item_model.dart';
import 'package:iremember/ui/views/base_view.dart';

import '../../locator.dart';

//TODO allow user to pick image and display the preview in UI
//TODO save new data to firestore (upload image to storage)

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String title;
  String description;

  File imageFile;
  Item item;

  GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    item = Item(title: "", description: "", imageUrl: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add item"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            _buildTitleField(),
            SizedBox(
              height: 20,
            ),
            _buildDescriptionField(),
            SizedBox(
              height: 20,
            ),
            imageFile != null
                ? Image.file(imageFile, height: 250.0)
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            _buildImgSelectButton(),
            SizedBox(
              height: 20,
            ),
            _buildSaveButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      onSaved: (value) => item.title = value,
      validator: (value) =>
          Validator.validateTextEmpty(value) ? null : "Title cannot be empty!",
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "title",
          prefixIcon: Icon(Icons.title)),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      onSaved: (value) => item.description = value,
      validator: (value) => Validator.validateTextEmpty(value)
          ? null
          : "Description cannot be empty!",
      onChanged: (value) {
        setState(() {
          description = value;
        });
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Description",
      ),
    );
  }

  Widget _buildImgSelectButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton.icon(
        icon: Icon(Icons.camera),
        label: Text("Add Image"),
        color: Colors.blue,
        onPressed: () {
          openCamera(context);
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return BaseWidget<ItemModel>(
      model: locator.get<ItemModel>(),
      builder: (context, itemModel, child) =>
        itemModel.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 50,
                  width: 20.0,
                  child: RaisedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Save"),
                    color: Colors.blue,
                    onPressed: () {
                      _saveToDatabase(itemModel);
                    },
                  ),
                ),
    );
  }

  void openCamera(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
    });

  }

  _saveToDatabase(ItemModel itemModel) async {

    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    await itemModel.addItem(item, imageFile);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Item Added successfully!!!"),
      duration: Duration(seconds: 2),
    ));

    Future.delayed(const Duration(seconds: 2), () {
      _formKey.currentState.reset();
      Navigator.pop(context);
    });
  }
}
