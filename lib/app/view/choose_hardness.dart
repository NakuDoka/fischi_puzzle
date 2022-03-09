import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';
import 'package:very_good_slide_puzzle/widgets/custombutton.dart';
import 'package:very_good_slide_puzzle/widgets/difficultybutton.dart';

class Choose_Hardness extends StatefulWidget {
  const Choose_Hardness({Key? key, required this.mode}) : super(key: key);
  final int mode;
  @override
  _Choose_HardnessState createState() => _Choose_HardnessState();
}

class _Choose_HardnessState extends State<Choose_Hardness> {
  @override
  void initState() {
    super.initState();
  }

  List<String> modes = ['Images', 'Numbers'];
  int whichActive = 1;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double fontSize = 35;
    if (height < 470) {
      fontSize = 20;
    } else if (height < 600) {
      fontSize = 25;
    } else if (height < 800 || width < 340) {
      fontSize = 30;
    }
    return Scaffold(
      backgroundColor: PuzzleColors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 844, minHeight: 370, maxWidth: width),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 15,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: PuzzleColors.black,
                            ),
                          ),
                          Text(
                            'Difficulty',
                            style: PuzzleTextStyle.headLine2W.copyWith(
                              fontSize: fontSize,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 40,
                    child: SizedBox(
                      child: RiveAnimation.asset(
                        'assets/rive/choose_mode.riv',
                        animations: widget.mode == 0 ? ['Numbers'] : ['Pics'],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 20,
                    child: Flex(
                      direction: width < 380 ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DifficultyButton(
                          text: 'BEGINNER',
                          function: () {
                            setState(() {
                              whichActive = 0;
                            });
                          },
                          isSelected: whichActive == 0,
                        ),
                        const SizedBox(
                          width: 8,
                          height: 8,
                        ),
                        DifficultyButton(
                          text: 'INTERMEDIATE',
                          function: () {
                            setState(() {
                              whichActive = 1;
                            });
                          },
                          isSelected: whichActive == 1,
                        ),
                        const SizedBox(
                          width: 8,
                          height: 8,
                        ),
                        DifficultyButton(
                          text: 'EXPERT',
                          function: () {
                            setState(() {
                              whichActive = 2;
                            });
                          },
                          isSelected: whichActive == 2,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 12,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Custombutton(
                        text: 'Start Solving',
                        color: PuzzleColors.blue,
                        function: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PuzzlePage(
                                tiles: whichActive + 3,
                                isImage: widget.mode == 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
