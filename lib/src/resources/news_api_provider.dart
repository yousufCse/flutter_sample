import 'package:flutter_sample/src/models/item_model.dart';
import 'package:flutter_sample/src/resources/repository.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  final client = Client();

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id');
    final parsedJson = json.decode(response.body);
    final item = ItemModel.fromJson(parsedJson);
    return item;
  }
}
