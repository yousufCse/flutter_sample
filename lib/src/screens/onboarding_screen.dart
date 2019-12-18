import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageValue = 0;
  final PageController controller = PageController(initialPage: 0);

  final List<Widget> introWidgets = <Widget>[
    Container(color: Colors.redAccent),
    Container(color: Colors.greenAccent),
    Container(color: Colors.blueAccent),
  ];

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            _buildPageView(),
            _buildIndicators(),
            _buildGetStarted(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: controller,
      physics: ClampingScrollPhysics(),
      itemCount: introWidgets.length,
      onPageChanged: getChangedPageAndMoveBar,
      itemBuilder: (context, index) {
        return introWidgets[index];
      },
    );
  }

  Widget _buildIndicators() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 35),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: introWidgets.asMap().entries.map((entry) {
                return circleBar(entry.key == currentPageValue);
              }).toList()),
        )
      ],
    );
  }

  Widget _buildGetStarted() {
    return Visibility(
      visible: currentPageValue == introWidgets.length - 1 ? true : false,
      child: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {},
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: isActive ? 20 : 15,
      width: isActive ? 20 : 15,
      decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
