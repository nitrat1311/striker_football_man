import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strikerFootballman/const/colors.dart';

import '../../game/game.dart';
import '../../screens/game_menu.dart';
import 'pause_button.dart';

// This class represents the game over menu overlay.
class GameOverMenu extends StatelessWidget {
  static const String id = 'GameOverMenu';
  final MasksweirdGame gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          Padding(
            padding: REdgeInsets.symmetric(vertical: 50.0),
            child: Stack(
              children: [
                Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 5.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = AppColors.textColorInsideGame,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 50.sp,
                      letterSpacing: 5.0,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 1
                        ..color = AppColors.gradientTitle2,
                      // color: ,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),

          // Restart button.
          Container(
            decoration: BoxDecoration(
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: AppColors.gradientTitle2, width: 4),
            ),
            child: FloatingActionButton.large(
              backgroundColor: AppColors.gradientTitle1,
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.id);
                gameRef.overlays.add(PauseButton.id);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Icon(
                Icons.restart_alt_rounded,
                color: AppColors.textButtonMenu,
              ),
            ),
          ),

          // Exit button.
          Container(
            decoration: BoxDecoration(
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: AppColors.gradientTitle2, width: 4),
            ),
            margin: REdgeInsets.only(top: 30),
            child: FloatingActionButton.large(
              backgroundColor: AppColors.gradientTitle1,
              elevation: 20,
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.id);
                gameRef.reset();
                gameRef.resumeEngine();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameMenu(),
                  ),
                );
              },
              child: const Icon(
                Icons.exit_to_app,
                color: AppColors.textButtonMenu,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
