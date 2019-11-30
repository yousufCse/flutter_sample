import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final int poll;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'],
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'],
        parent = parsedJson['parent'],
        poll = parsedJson['pool'],
        kids = parsedJson['kids'],
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'];

  ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] == 1,
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'] == 1,
        parent = parsedJson['parent'],
        poll = parsedJson['pool'],
        kids = jsonDecode(parsedJson['kids']),
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'by': by,
      'time': time,
      'parent': parent,
      'text': text,
      'poll': poll,
      'url': url,
      'score': score,
      'title': title,
      'descendants': descendants,
      'dead': dead ? 1 : 0,
      'deleted': deleted ? 1 : 0,
      'kids': jsonEncode(kids),
    };
  }
}
