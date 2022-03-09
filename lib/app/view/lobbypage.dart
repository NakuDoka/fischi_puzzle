import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/responsive_layout_builder.dart';
import 'package:very_good_slide_puzzle/models/ticker.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/puzzle/view/puzzle_page.dart';
import 'package:very_good_slide_puzzle/puzzle/view/puzzle_page_multi.dart';
import 'package:very_good_slide_puzzle/services/db.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/bloc/timer_bloc.dart';
import 'package:very_good_slide_puzzle/widgets/custombutton.dart';
import 'package:very_good_slide_puzzle/widgets/difficultybutton.dart';
import 'package:very_good_slide_puzzle/widgets/jumpingPlayer.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';
import 'package:very_good_slide_puzzle/widgets/jumpingPlayer.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  late DocumentSnapshot data;
  final db = ServerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PuzzleColors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 844, minHeight: 360),
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Servers')
                      .where('key', isEqualTo: widget.code)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      data = snapshot.data!.docs[0];
                    }
                    return snapshot.hasData
                        ? choosePage(context, data)
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget choosePage(BuildContext context, DocumentSnapshot data) {
    if (data.get('started').toString() == "false") {
      return lobby(context, data);
    } else {
      return gamePage();
    }
  }

  // Lobby page
  Widget lobby(BuildContext context, DocumentSnapshot data) {
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
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: SizedBox(
              width: 390,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      size: 35,
                      color: PuzzleColors.black,
                    ),
                  ),
                  Text(
                    'Game Lobby',
                    style: PuzzleTextStyle.headLine2W,
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 20,
          child: SizedBox(
            child: Row(
              children: [
                Text(
                  'Code: ',
                  style: PuzzleTextStyle.headLine2W,
                ),
                Text(
                  widget.code,
                  style: PuzzleTextStyle.headLine2W.copyWith(
                    color: PuzzleColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    JumpingPoet(index: 1),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        data.get('hostName').toString(),
                        style: PuzzleTextStyle.tileFontSmall,
                      ),
                    ),
                  ],
                ),
              ),
              data.get('guestName').toString() != ''
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          JumpingPoet(index: 2),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              data.get('guestName').toString(),
                              style: PuzzleTextStyle.tileFontSmall,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      width: 200,
                      height: 200,
                    ),
            ],
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
                  db.changeParameter(data.id, 'difficulty', 'BEGINNER');
                },
                isSelected: data.get('difficulty').toString() == 'BEGINNER',
              ),
              const SizedBox(
                width: 8,
                height: 8,
              ),
              DifficultyButton(
                text: 'INTERMEDIATE',
                function: () {
                  db.changeParameter(data.id, 'difficulty', 'INTERMEDIATE');
                },
                isSelected: data.get('difficulty').toString() == 'INTERMEDIATE',
              ),
              const SizedBox(
                width: 8,
                height: 8,
              ),
              DifficultyButton(
                text: 'EXPERT',
                function: () {
                  db.changeParameter(data.id, 'difficulty', 'EXPERT');
                },
                isSelected: data.get('difficulty').toString() == 'EXPERT',
              ),
            ],
          ),
        ),
        Flexible(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Custombutton(
              text: 'Start Game',
              color: PuzzleColors.pink,
              function: () {
                var ishere = data.get('guestName').toString() != '';
                if (ishere) {
                  db.changeParameter(data.id, 'started', true);
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget gamePage() {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;
    return Container();
  }
}
