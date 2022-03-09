import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:very_good_slide_puzzle/app/view/choose_hardness.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';
import 'package:very_good_slide_puzzle/widgets/choosemodebutton.dart';
import 'package:very_good_slide_puzzle/widgets/custombutton.dart';
import 'package:very_good_slide_puzzle/widgets/difficultybutton.dart';

class Choosehomepage extends StatefulWidget {
  const Choosehomepage({Key? key}) : super(key: key);

  @override
  _ChoosehomepageState createState() => _ChoosehomepageState();
}

class _ChoosehomepageState extends State<Choosehomepage> {
  StateMachineController? controller;
  SMIInput<int>? valueController;

  bool active = false;

  SMINumber? _bump;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'loop');
    artboard.addController(controller!);
    _bump = controller.findInput<double>('state') as SMINumber;
  }

  void _hitBump(int value) => _bump?.value = value as double;
  List<String> modes = ['Images', 'Numbers'];
  int whichActive = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double fontSize = 35;
    if (height < 470) {
      fontSize = 20;
    } else if (height < 600 || width < 340) {
      fontSize = 25;
    } else if (height < 800) {
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
              child: SizedBox(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: PuzzleColors.black,
                              ),
                            ),
                            Text(
                              'Choose Mode',
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
                          stateMachines: const ['loop'],
                          fit: BoxFit.fitHeight,
                          onInit: _onRiveInit,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DifficultyButton(
                            text: 'NUMBERS',
                            function: () {
                              _hitBump(2);
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
                            text: 'IMAGES',
                            function: () {
                              _hitBump(1);
                              setState(() {
                                whichActive = 2;
                              });
                            },
                            isSelected: whichActive == 2,
                          ),
                        ],
                      ),
                    ),
                    if (whichActive == 0)
                      const Flexible(
                        flex: 10,
                        child: SizedBox(),
                      )
                    else
                      Flexible(
                        flex: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Custombutton(
                            text: 'Choose',
                            color: PuzzleColors.blue,
                            function: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Choose_Hardness(
                                    mode: (whichActive - 1),
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
            ),
          ],
        ),
      ),
    );
  }
}
