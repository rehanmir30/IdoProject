import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(90),
      child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: const [Colors.white, Colors.red],
          strokeWidth: 3,
          backgroundColor: Color(0xFFFFFF),
          pathBackgroundColor: Colors.black
      ),
    );
  }
}
