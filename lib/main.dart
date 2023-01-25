import 'package:flutter/material.dart';
import 'package:flutter_sample/app.dart';
import 'package:flutter_sample/core/dependency.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(App());
}
