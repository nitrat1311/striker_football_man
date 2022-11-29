import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strikerFootballman/const/colors.dart';
import 'package:strikerFootballman/screens/game_menu.dart';
import 'package:provider/provider.dart';
import 'package:strikerFootballman/models/settings.dart';

// This class represents the settings menu.
class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        AppColors.gradientTitle1,
        AppColors.gradientTitle2,
      ],
    ).createShader(Rect.fromCenter(
        center: Offset(0, 45.h),
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 30));

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
            height: MediaQuery.of(context).size.height / 1.9,
            width: MediaQuery.of(context).size.width / 1.3,
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(colors: [
            //       Color.fromARGB(126, 81, 81, 9),
            //       Color.fromARGB(126, 58, 17, 0)
            //     ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            //     borderRadius: BorderRadius.all(Radius.circular(5))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                          foreground: Paint()
                            ..color = Colors.black
                            ..shader = linearGradient,
                          fontSize: 50.sp,
                          shadows: [
                            Shadow(
                              offset: const Offset(3, 2.0),
                              blurRadius: 4,
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(1),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Selector<Settings, bool>(
                    selector: (context, settings) => settings.soundEffects,
                    builder: (context, value, child) {
                      return SwitchListTile(
                        activeColor: AppColors.gradientTitle1,
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(65.0),
                            border: Border.all(
                              color: AppColors.gradientTitle2,
                              width: 4.0,
                            ),
                            color: AppColors.gradientTitle1,
                          ),
                          child: Container(
                              padding: REdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Sound',
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      color: AppColors.textButtonMenu,
                                      letterSpacing: 5),
                                ),
                              )),
                        ),
                        value: value,
                        onChanged: (newValue) {
                          Provider.of<Settings>(context, listen: false)
                              .soundEffects = newValue;
                        },
                      );
                    },
                  ),

                  // Switch for background music.
                  SizedBox(height: 25.h),

                  Selector<Settings, bool>(
                    selector: (context, settings) => settings.backgroundMusic,
                    builder: (context, value, child) {
                      return SwitchListTile(
                        activeColor: AppColors.gradientTitle1,
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(65.0),
                            border: Border.all(
                              color: AppColors.gradientTitle2,
                              width: 4.0,
                            ),
                            color: AppColors.gradientTitle1,
                          ),
                          child: Container(
                            padding: REdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(65),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Music',
                                style: TextStyle(
                                    fontSize: 25.sp,
                                    color: AppColors.textButtonMenu,
                                    letterSpacing: 5),
                              ),
                            ),
                          ),
                        ),
                        value: value,
                        onChanged: (newValue) {
                          Provider.of<Settings>(context, listen: false)
                              .backgroundMusic = newValue;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  // Back button.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border:
                          Border.all(color: AppColors.gradientTitle2, width: 4),
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.gradientTitle1,
                      onPressed: () {
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
