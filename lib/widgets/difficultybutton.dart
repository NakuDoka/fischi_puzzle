import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class DifficultyButton extends StatefulWidget {
  const DifficultyButton({Key? key, required this.function, required this.text, required this.isSelected})
      : super(key: key);
  final Function function;
  final String text;
  final bool isSelected;

  @override
  State<DifficultyButton> createState() => _DifficultyButtonState();
}

class _DifficultyButtonState extends State<DifficultyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.function(),
      child: HoverAnimatedContainer(
        width: 115,
        height: 30,
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: widget.isSelected ? PuzzleColors.pink : PuzzleColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: PuzzleColors.pink, width: widget.isSelected ? 0 : 2),
        ),
        hoverDecoration: BoxDecoration(
          color: widget.isSelected ? PuzzleColors.pink : PuzzleColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: PuzzleColors.pink, width: widget.isSelected ? 0 : 2),
          boxShadow: const [
            BoxShadow(
              color: PuzzleColors.pinkHover,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: PuzzleTextStyle.buttonText3.copyWith(
              color: widget.isSelected ? PuzzleColors.white : PuzzleColors.pink,
            ),
          ),
        ),
      ),
    );
  }
}
