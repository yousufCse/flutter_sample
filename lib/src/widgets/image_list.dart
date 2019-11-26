import 'package:flutter/material.dart';
import '../models/image_model.dart';
import '../widgets/items/iamge_item.dart';

class ImageListWiget extends StatelessWidget {
  final List<ImageModel> images;

  ImageListWiget(this.images);

  Widget build(context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        return ImageItem(item);
      },
    );
  }
}
