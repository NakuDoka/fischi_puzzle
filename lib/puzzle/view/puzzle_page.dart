import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/services/provider.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key, required this.tiles, required this.isImage}) : super(key: key);
  final int tiles;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(
        themes: const [
          SimpleTheme(),
        ],
      ),
      child: PuzzleView(
        tiles: tiles,
        isImage: isImage,
      ),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key, required this.tiles, required this.isImage}) : super(key: key);
  final int tiles;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      backgroundColor: PuzzleColors.white,
      body: BlocProvider(
        create: (context) => TimerBloc(
          ticker: const Ticker(),
        ),
        child: BlocProvider(
          create: (context) => PuzzleBloc(
            isImage && tiles == 5 ? 4 : tiles,
          ) // Changes how many rows and columns
            ..add(
              PuzzleInitialized(
                shufflePuzzle: shufflePuzzle,
              ),
            ),
          child: _Puzzle(
            key: Key('puzzle_view_puzzle'),
            isImage: isImage,
            tiles: tiles,
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key, required this.isImage, required this.tiles}) : super(key: key);
  final bool isImage;
  final int tiles;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 12),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: PuzzleColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _PuzzleSections(
                      key: Key('puzzle_sections'),
                      isImage: isImage,
                      tiles: tiles,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PuzzleSections extends StatelessWidget {
  const _PuzzleSections({Key? key, required this.isImage, required this.tiles}) : super(key: key);
  final bool isImage;
  final int tiles;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final mode = isImage ? 'Img${tiles - 2}' : 'Num${tiles - 2}';

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          PuzzleBoard(
            isImage: isImage,
            tiles: tiles,
          ),
          theme.layoutDelegate.endSectionBuilder(state, mode),
        ],
      ),
      medium: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          PuzzleBoard(
            tiles: tiles,
            isImage: isImage,
          ),
          theme.layoutDelegate.endSectionBuilder(state, mode),
        ],
      ),
      large: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          PuzzleBoard(
            isImage: isImage,
            tiles: tiles,
          ),
          theme.layoutDelegate.endSectionBuilder(state, mode),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key, required this.isImage, required this.tiles}) : super(key: key);
  final bool isImage;
  final int tiles;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerBloc>().add(const TimerStopped());
        }
      },
      child: theme.layoutDelegate.boardBuilder(
        size,
        puzzle.tiles
            .map(
              (tile) => _PuzzleTile(
                key: Key('puzzle_tile_${tile.value.toString()}'),
                tile: tile,
                isImage: isImage,
                tiles: tiles,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({Key? key, required this.tile, required this.isImage, required this.tiles}) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  ///
  final bool isImage;

  ///
  final int tiles;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state, isImage, tiles);
  }
}
