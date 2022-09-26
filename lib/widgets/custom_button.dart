import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.tag,
    this.width = 180,
    this.color,
    this.icon,
  }) : super(key: key);
  final Function() onPressed;
  final String text;
  final double width;
  final IconData? icon;
  final Color? color;
  final Object? tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FloatingActionButton.extended(
        heroTag: tag,
        backgroundColor: color ?? Colors.blueAccent,
        icon: Icon(icon ?? Icons.arrow_forward_ios),
        onPressed: onPressed,
        label: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
