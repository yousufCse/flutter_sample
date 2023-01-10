import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sample/widgets/glass_morphism.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            Image.network(
              'https://img.theweek.in/content/dam/week/webworld/feature/lifestyle/2017/december/chicken-biriyani.jpg',
              fit: BoxFit.fitWidth,
            ),
            Column(
              children: [
                GlassMoorphism(
                    blur: 5,
                    radius: 15,
                    opacity: 0.3,
                    child: Container(
                        height: 100,
                        width: 200,
                        child: Center(
                          child: Text(
                            'Welcome to Food App',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
