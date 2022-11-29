import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strikerFootballman/app_state.dart';
import 'package:strikerFootballman/const/colors.dart';
import 'package:strikerFootballman/screens/where_to_go.dart';
import 'package:strikerFootballman/utils/network.dart';

class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    AppState().removeSplashScreen();
    return Scaffold(
      floatingActionButton: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 10),
        decoration: BoxDecoration(
          borderRadius: AppColors.borderRadius,
          border: Border.all(color: AppColors.gradientTitle2, width: 4),
        ),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: AppColors.gradientTitle1,
          onPressed: () async {
            await isInternetConnectionAvailable()
                ? Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const WhereToGoWidget(),
                    ),
                  )
                : {};
          },
          child: const Icon(
            Icons.refresh,
            color: AppColors.gradientTitle2,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/scaffold_back.png',
            width: 428,
            height: 926,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 8),
                    child: Stack(
                      children: [
                        Text(
                          'No Internet',
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
                          'No Internet',
                          style: TextStyle(
                              fontSize: 50.sp,
                              letterSpacing: 5.0,
                              foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..strokeWidth = 1
                                ..color = AppColors.gradientTitle2,
                              fontWeight: FontWeight.bold),
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
    );
  }
}
