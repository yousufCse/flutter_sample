import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../src/models/image_model.dart';
import '../src/widgets/image_list.dart';

class App extends StatefulWidget {
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int counter = 0;

  List<ImageModel> images = [];

  void fabPressed() async {
    print('FAB Pressed');
    counter += 1;

    var response =
        await http.get('https://jsonplaceholder.typicode.com/photos/$counter');
    var image = ImageModel.fromJson(json.decode(response.body));

    setState(() {
      images.add(image);
    });
  }

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: ImageListWiget(images),
        appBar: AppBar(
          title: Text('Lets see images here!'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fabPressed,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
