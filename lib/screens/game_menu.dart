import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strikerFootballman/const/colors.dart';
import 'package:strikerFootballman/screens/records_table.dart';
import 'package:provider/provider.dart';
import 'package:strikerFootballman/app_state.dart';
import 'package:strikerFootballman/models/view_or_game.dart';
import 'package:strikerFootballman/widgets/glowing_button.dart';

import 'settings_menu.dart';
import 'select_spaceship.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!AppState().isDevMode) {
      Future.delayed(Duration.zero, () {
        Provider.of<ViewOrGameData>(context, listen: false).startedGame = true;
      });
    }

    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.gradientTitle1,
        AppColors.gradientTitle2,
      ],
    ).createShader(Rect.fromCenter(
        center: Offset(0, 90.h),
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 30));
    AppState().removeSplashScreen();
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/scaffold_back.png',
          width: 428,
          height: 926,
          fit: BoxFit.cover,
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            width: MediaQuery.of(context).size.width / 1.3,
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(colors: [
            //       Color.fromARGB(126, 81, 81, 9),
            //       Color.fromARGB(126, 58, 17, 0)
            //     ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            //     borderRadius: BorderRadius.all(Radius.circular(5))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: REdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: AutoSizeText(
                      'Sport Fan Tips',
                      wrapWords: false,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          foreground: Paint()
                            ..color = Colors.black
                            ..shader = linearGradient,
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          shadows: [
                            Shadow(
                              offset: const Offset(3, 3.0),
                              blurRadius: 8,
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(1),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SelectCharacter(),
                          ),
                        );
                      },
                      child: GlowingButton(
                        child: Text(
                          'new game',
                          style: TextStyle(
                              color: AppColors.textButtonMenu, fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecordsTable(),
                          ),
                        );
                      },
                      child: GlowingButton(
                        child: Text(
                          'records',
                          style: TextStyle(
                              color: AppColors.textButtonMenu, fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsMenu(),
                          ),
                        );
                      },
                      child: GlowingButton(
                        child: Text(
                          'settings',
                          style: TextStyle(
                              color: AppColors.textButtonMenu, fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h)
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
