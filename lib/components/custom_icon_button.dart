import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{
  final GestureTapCallback onPressed;
  final IconData iconData;

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(iconData),
      color: Colors.white,
      iconSize: 30.0,
    );
  }
}