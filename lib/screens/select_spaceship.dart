import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strikerFootballman/const/colors.dart';

import 'game_play.dart';

// Represents the spaceship selection menu from where player can
// change current spaceship or buy a new one.
class SelectCharacter extends StatelessWidget {
  const SelectCharacter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Color.fromARGB(255, 255, 174, 0),
        Color.fromRGBO(0, 255, 194, 1)
      ],
    ).createShader(const Rect.fromLTWH(0.0, 200.0, 200.0, 100.0));

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/ship_A.png',
          width: 428,
          height: 926,
          fit: BoxFit.cover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start button.
              Container(
                margin: REdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 1.1),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gradientTitle2, width: 4),
                  borderRadius: AppColors.borderRadius,
                ),
                child: FloatingActionButton.small(
                  heroTag: null,
                  backgroundColor: AppColors.gradientTitle1,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GamePlay(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.textButtonMenu,
                  ),
                ),
              ),

              // // Back button.
              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.purple, width: 4),
              //     shape: BoxShape.circle,
              //   ),
              //   child: FloatingActionButton.small(
              //     heroTag: null,
              //     backgroundColor: Colors.amber,
              //     onPressed: () {
              //       Navigator.of(context).pushReplacement(
              //         MaterialPageRoute(
              //           builder: (context) => const GameMenu(),
              //         ),
              //       );
              //     },
              //     child: const Icon(
              //       Icons.exit_to_app,
              //       color: Colors.purple,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}
