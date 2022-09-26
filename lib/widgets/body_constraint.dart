import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BodyWidget extends StatelessWidget {
  double? hRatio;
  double? wRatio;
  Widget child;

  BodyWidget({Key? key, required this.child, this.hRatio, this.wRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        constraints: hRatio != null && wRatio != null
            ? BoxConstraints(
                maxHeight: height * hRatio!, maxWidth: width * wRatio!)
            : BoxConstraints(maxHeight: height * 0.95, maxWidth: width * 0.95),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: child,
        ),
      ),
    );
  }
}
