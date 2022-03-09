import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// Defines text styles for the puzzle UI.
class PuzzleTextStyle {
  /// Headline 2 text style
  static final headLine2W = GoogleFonts.fredokaOne(
    color: PuzzleColors.black,
    fontSize: 35,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final headLine1W = GoogleFonts.fredokaOne(
    color: PuzzleColors.white,
    fontSize: 35,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final headLine2D = GoogleFonts.fredokaOne(
    color: PuzzleColors.white,
    fontSize: 20,
    fontWeight: PuzzleFontWeight.regular,
  );

  /// Button Text
  static final buttonText1 = GoogleFonts.fredokaOne(
    color: PuzzleColors.white,
    fontSize: 25,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final buttonText2 = GoogleFonts.fredokaOne(
    color: PuzzleColors.white,
    fontSize: 20,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final buttonText3 = GoogleFonts.fredokaOne(
    color: PuzzleColors.pink,
    fontSize: 13,
    fontWeight: PuzzleFontWeight.regular,
  );

  static final buttonText3A = GoogleFonts.fredokaOne(
    color: PuzzleColors.white,
    fontSize: 13,
    fontWeight: PuzzleFontWeight.regular,
  );

  /// Text Field text
  static final textFieldText = GoogleFonts.poppins(
    color: PuzzleColors.black,
    fontSize: 15,
    fontWeight: PuzzleFontWeight.medium,
  );

  /// Body text
  static final bodyText = GoogleFonts.poppins(
    color: PuzzleColors.black,
    fontSize: 20,
    fontWeight: PuzzleFontWeight.medium,
  );

  static final bodyTextBold = GoogleFonts.poppins(
    color: PuzzleColors.black,
    fontSize: 20,
    fontWeight: PuzzleFontWeight.semiBold,
  );

  static final tileFontSmall = GoogleFonts.fredokaOne(
    color: PuzzleColors.black,
    fontSize: 25,
    fontWeight: PuzzleFontWeight.regular,
  );
}
