import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:very_good_slide_puzzle/app/view/lobbypage.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/services/db.dart';
import 'package:very_good_slide_puzzle/services/provider.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';
import 'package:very_good_slide_puzzle/widgets/custombutton.dart';
import 'package:very_good_slide_puzzle/widgets/customtextfield.dart';

class MultiplayerPage extends StatefulWidget {
  const MultiplayerPage({Key? key}) : super(key: key);

  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  final db = ServerService();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var controller = TextEditingController();
    double fontSize = 35;
    if (height < 470) {
      fontSize = 23;
    } else if (height < 600) {
      fontSize = 27;
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
              child: SizedBox(
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back, size: 30, color: PuzzleColors.black),
                            ),
                            Text(
                              'Multiplayer',
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
                    const Flexible(
                      flex: 40,
                      child: RiveAnimation.asset(
                        'assets/rive/choose_mode.riv',
                        animations: ['Numbers'],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Flexible(
                      flex: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CustomTextField(
                                text: 'Enter Game Code',
                                controller: controller,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Custombutton(
                                text: 'Join Game',
                                color: PuzzleColors.blue,
                                function: () {},
                              ),
                            ],
                          ),
                          Text(
                            'OR',
                            style: PuzzleTextStyle.headLine2W.copyWith(
                              fontSize: fontSize,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Custombutton(
                              text: 'Create Game',
                              color: PuzzleColors.pink,
                              function: () async {
                                var key = await db.createLobby();
                                // ignore: use_build_context_synchronously
                                await Navigator.push<void>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LobbyPage(
                                      code: key,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
