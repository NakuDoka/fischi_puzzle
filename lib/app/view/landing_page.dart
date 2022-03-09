import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:very_good_slide_puzzle/app/view/choose_mode_page.dart';
import 'package:very_good_slide_puzzle/app/view/multiplayer_page.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/services/db.dart';
import 'package:very_good_slide_puzzle/services/provider.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';
import 'package:very_good_slide_puzzle/widgets/custombutton.dart';
import 'package:very_good_slide_puzzle/widgets/customtextfield.dart';
import 'package:very_good_slide_puzzle/widgets/landingpagebutton.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({Key? key}) : super(key: key);

  @override
  _LandingpageState createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  final db = DatabaseService();

  void _openDialog(BuildContext context) async {
    var controller = TextEditingController();
    var provider = Provider.of<GameProvider>(context, listen: false);
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Container(
            height: 180,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enter a Name',
                  style: PuzzleTextStyle.tileFontSmall,
                ),
                CustomTextField(
                  text: 'Playername',
                  controller: controller,
                ),
                Custombutton(
                  text: 'Play',
                  color: PuzzleColors.blue,
                  function: () async {
                    if (controller.text.length > 1) {
                      await db.signInAnon(context, controller.text);
                      provider.changePlayerName(controller.text);
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Choosehomepage(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final auth = FirebaseAuth.instance;
    double fontSize = 35;
    if (height < 470) {
      fontSize = 18;
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
              constraints: const BoxConstraints(
                maxHeight: 844,
                minHeight: 360,
              ),
              child: SizedBox(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Fischi',
                            style: PuzzleTextStyle.headLine2W.copyWith(fontSize: fontSize),
                          ),
                          Row(
                            children: [
                              Text(
                                'Puzzle Game',
                                style: PuzzleTextStyle.headLine2W.copyWith(fontSize: fontSize),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        if (auth.currentUser == null) {
                          _openDialog(context);
                        } else {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Choosehomepage(),
                            ),
                          );
                        }
                      },
                      child: const Landingpagebutton(
                        text: 'Singleplayer',
                        image: 'assets/images/singleplayer.svg',
                        color: PuzzleColors.pink,
                        hovercolor: PuzzleColors.pinkHover,
                      ),
                    ),
                    const SizedBox()
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
