import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/typography/text_styles.dart';

class Leaderboards extends StatefulWidget {
  const Leaderboards({Key? key, required this.mode}) : super(key: key);
  final String mode;

  @override
  _LeaderboardsState createState() => _LeaderboardsState();
}

class _LeaderboardsState extends State<Leaderboards> {
  // Stream
  late Future<QuerySnapshot> leaderboardData;

  @override
  void initState() {
    leaderboardData = getleaderboard(widget.mode);
    super.initState();
  }

  Future<QuerySnapshot> getleaderboard(String mode) async {
    final _getLeaderboardFuture = FirebaseFirestore.instance
        .collection('Leaderboard')
        .orderBy('Score')
        .where('Type', isEqualTo: mode)
        .limit(100)
        .get();
    return _getLeaderboardFuture;
  }

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
    List<Color> colorList = [
      Color.fromRGBO(240, 162, 40, 1),
      Color.fromRGBO(61, 198, 252, 1),
      Color.fromRGBO(77, 215, 182, 1)
    ];
    return Scaffold(
      backgroundColor: PuzzleColors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 844, minHeight: 370, maxWidth: 390, minWidth: 200),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          'Leaderboard',
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
                  FutureBuilder(
                      future: leaderboardData,
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return !snapshot.hasData
                            ? const Center(child: CircularProgressIndicator())
                            : Flexible(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 10),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data?.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data?.docs[index];
                                    return data!.exists
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: index < 3 ? colorList[index] : Colors.grey[300],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      data.get('Name').toString(),
                                                      style: index < 3
                                                          ? PuzzleTextStyle.textFieldText.copyWith(color: Colors.white)
                                                          : PuzzleTextStyle.textFieldText,
                                                    ),
                                                    Text(
                                                      'Tiles: ${data.get('Score')}',
                                                      style: index < 3
                                                          ? PuzzleTextStyle.textFieldText.copyWith(color: Colors.white)
                                                          : PuzzleTextStyle.textFieldText,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'No Highscores Found',
                                                  style: PuzzleTextStyle.headLine2W,
                                                ),
                                                SizedBox(
                                                    width: 200,
                                                    child: SvgPicture.asset(
                                                      'assets/images/nodata.svg',
                                                      fit: BoxFit.fitWidth,
                                                    )),
                                              ],
                                            ),
                                          );
                                  },
                                ),
                              );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
