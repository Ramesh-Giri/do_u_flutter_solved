import 'package:flutter/material.dart';
import 'package:iremember/core/enums.dart';
import 'package:iremember/core/view_models/item_model.dart';
import 'package:iremember/ui/views/base_view.dart';

import '../../locator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: Icon(Icons.home),
        backgroundColor: Colors.blueAccent,
      ),
      body: BaseWidget<ItemModel>(
          model: locator.get<ItemModel>(),
          onModelReady: (model) => model.getItems(),
          builder: (context, model, child) {
            if (model.state == ViewState.Busy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (model.errorMessage.isNotEmpty) {
              return Center(
                child: Text("Something went Wrong"),
              );
            }

            if (model.allItems().isEmpty) {
              return Center(
                child: Text("Nothing to show!!!"),
              );
            }
            return ListView.builder(
              itemCount: model.allItems().length,
              itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(model.allItems()[index].value["image"]),
                          fit: BoxFit.cover)),
                ),
                title: Text(model.allItems()[index].value["title"] ?? ""),
                subtitle: Text(model.allItems()[index].value["description"]?? ""),
              );
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add_new");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
