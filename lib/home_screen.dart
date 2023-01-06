import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onErrorPress() {
    Flushbar(
      // titleText: const Text('Error new'),
      messageText: const Text('While fetching user info'),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      margin: const EdgeInsets.only(top: 4, left: 16, right: 30),
      borderRadius: BorderRadius.circular(8),
      // flushbarStyle: FlushbarStyle.GROUNDED,
      
      
    ).show(context);
  }

  void onSuccessPress() {}
  void onInfoPress() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onErrorPress,
              child: const Text('Show Error Snackbar'),
            ),
            ElevatedButton(
              onPressed: onSuccessPress,
              child: const Text('Show Success Snackbar'),
            ),
            ElevatedButton(
                onPressed: onInfoPress,
                child: const Text('Show Info Snackbar')),
          ],
        ),
      ),
    );
  }
}
