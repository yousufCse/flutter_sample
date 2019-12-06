import 'package:flutter_sample/src/models/item_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  final client = Client();

  fetchTopIds() async {
    final response =
        await client.get('$_root/topstories');
    final ids = json.decode(response.body);
    return ids;
  }

  fetchItem(int id) async {
    final response =
        await client.get('$_root/item/$id');
    final parsedJson = json.decode(response.body);
    final item = ItemModel.fromJson(parsedJson);
    return item;
  }
}
