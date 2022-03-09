import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class Choosemodebutton extends StatefulWidget {
  const Choosemodebutton({Key? key, required this.text, required this.function, required this.isElevated})
      : super(key: key);
  final String text;
  final Function function;
  final bool isElevated;
  @override
  State<Choosemodebutton> createState() => _ChoosemodebuttonState();
}

class _ChoosemodebuttonState extends State<Choosemodebutton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.function(),
      child: HoverAnimatedContainer(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: PuzzleColors.pink,
          boxShadow: widget.isElevated
              ? const [
                  BoxShadow(
                    color: PuzzleColors.pinkHover,
                    offset: Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: PuzzleColors.pinkHover,
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        hoverDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: PuzzleColors.pink,
          boxShadow: const [
            BoxShadow(
              color: PuzzleColors.pinkHover,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: PuzzleColors.pinkHover,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: PuzzleTextStyle.buttonText2,
          ),
        ),
      ),
    );
  }
}
