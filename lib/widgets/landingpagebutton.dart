import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class Landingpagebutton extends StatefulWidget {
  const Landingpagebutton(
      {Key? key, required this.text, required this.image, required this.color, required this.hovercolor})
      : super(key: key);
  final String text;
  final String image;
  final Color color;
  final Color hovercolor;
  @override
  _LandingpagebuttonState createState() => _LandingpagebuttonState();
}

class _LandingpagebuttonState extends State<Landingpagebutton> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double fontSize = 35;
    double multiplyer = 1.0;
    if (height < 282 || width < 230) {
      fontSize = 14;
      multiplyer = 0.5;
    } else if (height < 380 || width < 400) {
      fontSize = 20;
      multiplyer = 0.7;
    }
    return HoverWidget(
      onHover: (e) {},
      hoverChild: AnimatedContainer(
        width: 300 * multiplyer,
        height: 264 * multiplyer,
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: widget.hovercolor, offset: Offset(8, 8), blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.text,
              style: PuzzleTextStyle.headLine1W.copyWith(fontSize: fontSize),
            ),
            SizedBox(
              width: 220 * multiplyer,
              height: 220 * multiplyer,
              child: SvgPicture.asset(
                widget.image,
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
      child: AnimatedContainer(
        width: 300 * multiplyer,
        height: 264 * multiplyer,
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.text,
              style: PuzzleTextStyle.headLine1W.copyWith(fontSize: fontSize),
            ),
            SizedBox(
              width: 220 * multiplyer,
              height: 220 * multiplyer,
              child: SvgPicture.asset(
                widget.image,
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}
