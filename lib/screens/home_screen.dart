import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int secs = 0;

  Timer? timer;

  bool isTimerRunning = false;

  startTimer() {
    if (isTimerRunning) return;

    isTimerRunning = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      debugPrint('Home Screen Timer: $secs');
      setState(() {
        secs++;
      });
    });
  }

  stopTimer() {
    isTimerRunning = false;
    if (timer != null) timer?.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    debugPrint('Home Screen dispose called');
    super.dispose();
  }

  String popupIndex = 'Item 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              secs.toString(),
              style: Theme.of(context).textTheme.headline3,
            ),
            ElevatedButton(onPressed: startTimer, child: Text('Start Timer')),
            OutlinedButton(onPressed: stopTimer, child: Text('Stop Timer')),
            TextButton(onPressed: () {}, child: Text('Text Button')),
            MaterialButton(onPressed: () {}, child: Text('Material Button')),
            DropdownButton(
              items: [
                DropdownMenuItem(child: Text('Dropdown Menu Item 1')),
              ],
              onChanged: (value) {},
            ),
            PopupMenuButton<String>(
              child: Text(popupIndex),
              onSelected: (value) {
                debugPrint('Popup Selected Value: $value');
                setState(() {
                  popupIndex = value;
                });
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: Text('Item 1')),
                  PopupMenuItem(child: Text('Item 2')),
                  PopupMenuItem(child: Text('Item 3')),
                ];
              },
            ),
            ButtonBar(
              children: [Text('Bar 1'), Text('Bar 2')],
            )
          ],
        ),
      ),
    );
  }
}
