import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template puzzle_title}
/// Displays the title of the puzzle in the given color.
/// {@endtemplate}
class PuzzleTitle extends StatelessWidget {
  /// {@macro puzzle_title}
  const PuzzleTitle({
    Key? key,
    required this.title,
    this.color = PuzzleColors.black,
  }) : super(key: key);

  /// The title to be displayed.
  final String title;

  /// The color of the [title], defaults to [PuzzleColors.primary1].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => Center(
        child: SizedBox(
          width: 300,
          child: Center(
            child: Text('lol', textAlign: TextAlign.center, style: PuzzleTextStyle.bodyText),
          ),
        ),
      ),
      medium: (context, child) => Center(
        child: Text('lol', style: PuzzleTextStyle.bodyText),
      ),
      large: (context, child) => Center(
        child: Text('lol', style: PuzzleTextStyle.bodyText),
      ),
    );
  }
}
 // TODO check this