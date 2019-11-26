import 'package:flutter/material.dart';
import '../../models/image_model.dart';

class ImageItem extends StatelessWidget {
  final ImageModel image;

  ImageItem(this.image);

  void onListTap() {
    print('onTap: ${image.title}');
  }

  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Image.network(image.url),
          ),
          Text(image.title),
        ],
      ),
    );
  }
}
