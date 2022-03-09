import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class Custombutton extends StatefulWidget {
  const Custombutton({Key? key, required this.text, required this.color, required this.function}) : super(key: key);
  final String text;
  final Color color;
  final Function function;
  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: widget.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: Size(204, 45)),
      onPressed: () => widget.function(),
      child: Text(
        widget.text,
        style: PuzzleTextStyle.buttonText1,
      ),
    );
  }
}
