import 'package:flutter/material.dart';
import 'package:strikerFootballman/const/colors.dart';

class GlowingButton extends StatefulWidget {
  final Widget child;

  const GlowingButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  GlowingButtonState createState() => GlowingButtonState();
}

class GlowingButtonState extends State<GlowingButton> {
  var glowing = false;
  var scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height / 12,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gradientTitle2, width: 3.65),
        borderRadius: BorderRadius.circular(45),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 167, 69, 95),
            Color.fromARGB(255, 255, 115, 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.solid,
            offset: const Offset(0, 9.0),
            blurRadius: 26,
            color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.2),
          ),
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
            child: widget.child),
      ]),
    );
  }
}
