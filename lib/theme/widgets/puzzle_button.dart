import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  const PuzzleButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    required this.isImage,
  }) : super(key: key);

  /// The background color of this button.
  final Color? backgroundColor;

  /// The text color of this button.
  final Color? textColor;

  /// Called when this button is tapped.
  final VoidCallback onPressed;

  /// The label of this button.
  final String text;

  /// bool
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 204,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: backgroundColor,
          textStyle: PuzzleTextStyle.buttonText1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            if (isImage)
              SvgPicture.asset(
                'assets/images/shuffle-icon.svg',
                height: 24,
                width: 24,
                color: PuzzleColors.white,
              ),
            Text(text),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
