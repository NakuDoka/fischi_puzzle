import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PuzzleTextStyle', () {
    test('headline styles are defined', () {
      expect(PuzzleTextStyle.headLine1D, isA<TextStyle>());
      expect(PuzzleTextStyle.headLine1W, isA<TextStyle>());
      expect(PuzzleTextStyle.headLine2D, isA<TextStyle>());
      expect(PuzzleTextStyle.headLine2W, isA<TextStyle>());
    });

    test('body styles are defined', () {
      expect(PuzzleTextStyle.bodyText, isA<TextStyle>());
      expect(PuzzleTextStyle.bodyTextBold, isA<TextStyle>());
    });

    test('label style is defined', () {
      expect(PuzzleTextStyle.bodyText, isA<TextStyle>());
    });
  });
}
