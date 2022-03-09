import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/reorderable_grid_view.dart';
import 'package:very_good_slide_puzzle/app/view/leaderboards.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/services/db.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state, String mode) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 48,
        ),
        // ignore: prefer_if_elements_to_conditional_expressions
        state.puzzleStatus != PuzzleStatus.complete
            ? ResponsiveLayoutBuilder(
                small: (_, child) => const SimplePuzzleShuffleButton(),
                medium: (_, child) => const SimplePuzzleShuffleButton(),
                large: (_, __) => const SimplePuzzleShuffleButton(),
              )
            : ResponsiveLayoutBuilder(
                small: (_, child) => SimplePuzzleShuffleButtonColumn(
                  mode: mode,
                  state: state,
                ),
                medium: (_, child) => SimplePuzzleShuffleButtonColumn(
                  mode: mode,
                  state: state,
                ),
                large: (_, __) => SimplePuzzleShuffleButtonColumn(
                  mode: mode,
                  state: state,
                ),
              ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return SizedBox();
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state, bool isImage, int tiles) {
    return isImage
        ? ResponsiveLayoutBuilder(
            small: (_, __) => SimplePuzzleTileImg(
              key: Key('simple_puzzle_tile_${tile.value}_small'),
              tile: tile,
              tileFontSize: _TileFontSize.small,
              state: state,
              tiles: tiles,
            ),
            medium: (_, __) => SimplePuzzleTileImg(
              key: Key('simple_puzzle_tile_${tile.value}_medium'),
              tile: tile,
              tileFontSize: _TileFontSize.medium,
              state: state,
              tiles: tiles,
            ),
            large: (_, __) => SimplePuzzleTileImg(
              key: Key('simple_puzzle_tile_${tile.value}_large'),
              tile: tile,
              tileFontSize: _TileFontSize.large,
              state: state,
              tiles: tiles,
            ),
          )
        : ResponsiveLayoutBuilder(
            small: (_, __) => SimplePuzzleTile(
              key: Key('simple_puzzle_tile_${tile.value}_small'),
              tile: tile,
              tileFontSize: _TileFontSize.small,
              state: state,
            ),
            medium: (_, __) => SimplePuzzleTile(
              key: Key('simple_puzzle_tile_${tile.value}_medium'),
              tile: tile,
              tileFontSize: _TileFontSize.medium,
              state: state,
            ),
            large: (_, __) => SimplePuzzleTile(
              key: Key('simple_puzzle_tile_${tile.value}_large'),
              tile: tile,
              tileFontSize: _TileFontSize.large,
              state: state,
            ),
          );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 83,
        ),
        const PuzzleName(),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 16,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete ? context.l10n.puzzleCompleted : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ReorderableGridView.count(
      onReorder: (_, __) {},
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      enableReorder: false,
      enableLongPress: false,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 25;
  static double medium = 40;
  static double large = 40;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.tileFontSmall.copyWith(
          fontSize: tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              return theme.pressedColor;
            } else if (states.contains(MaterialState.hovered)) {
              return theme.hoverColor;
            } else {
              return theme.defaultColor;
            }
          },
        ),
      ),
      onPressed:
          state.puzzleStatus == PuzzleStatus.incomplete ? () => context.read<PuzzleBloc>().add(TileTapped(tile)) : null,
      child: Text(tile.value.toString()),
    );
  }
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTileImg extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTileImg(
      {Key? key, required this.tile, required this.tileFontSize, required this.state, required this.tiles})
      : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  final int tiles;

  @override
  Widget build(BuildContext context) {
    //final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    return InkWell(
      onTap:
          state.puzzleStatus == PuzzleStatus.incomplete ? () => context.read<PuzzleBloc>().add(TileTapped(tile)) : null,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/folder${tiles - 2}/${tile.value}.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
        isImage: true,
        textColor: PuzzleColors.white,
        backgroundColor: PuzzleColors.blue,
        onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
        text: 'Shuffle');
  }
}

class SimplePuzzleShuffleButtonColumn extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButtonColumn({Key? key, required this.mode, required this.state}) : super(key: key);
  final String mode;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final ProgressDialog pr = ProgressDialog(context);
    return SizedBox(
      height: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PuzzleButton(
            textColor: PuzzleColors.white,
            backgroundColor: PuzzleColors.blue,
            onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
            isImage: false,
            text: 'Try Again',
          ),
          PuzzleButton(
            textColor: PuzzleColors.white,
            backgroundColor: PuzzleColors.pink,
            isImage: false,
            onPressed: () async {
              await pr.show();
              await db.addLeaderboard(mode, state.numberOfMoves);
              await pr.hide();
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Leaderboards(
                            mode: mode,
                          )));
            },
            text: 'Leaderboards',
          ),
        ],
      ),
    );
  }
}
