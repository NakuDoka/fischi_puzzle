import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';

class JumpingPoet extends StatefulWidget {
  final int index;
  const JumpingPoet({Key? key, required this.index}) : super(key: key);

  @override
  _JumpingPoetState createState() => _JumpingPoetState();
}

class _JumpingPoetState extends State<JumpingPoet> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'jump',
      autoplay: true,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        // ignore: unnecessary_statements
        _isPlaying ? null : _controller.isActive = true;
      },
      hoverColor: PuzzleColors.white,
      splashColor: PuzzleColors.white,
      focusColor: PuzzleColors.white,
      highlightColor: PuzzleColors.white,
      child: SizedBox(
        width: 200,
        child: RiveAnimation.asset(
          'assets/rive/jump${widget.index.toString()}.riv',
          controllers: [_controller],
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
