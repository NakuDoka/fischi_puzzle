import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key, required this.text, required this.controller}) : super(key: key);
  final String text;
  final TextEditingController controller;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 204,
      height: 45,
      child: TextField(
        controller: widget.controller,
        textAlign: TextAlign.center,
        style: PuzzleTextStyle.textFieldText,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PuzzleColors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PuzzleColors.blue, width: 2),
          ),
          hintText: widget.text,
          hintStyle: PuzzleTextStyle.textFieldText,
        ),
      ),
    );
  }
}
