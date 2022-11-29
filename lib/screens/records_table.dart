import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strikerFootballman/const/colors.dart';
import 'package:strikerFootballman/game/records/bloc/records_bloc.dart';
import 'package:strikerFootballman/game/records/model/record.dart';
import 'package:strikerFootballman/screens/game_menu.dart';
import 'package:strikerFootballman/utils/separated_column.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordsTable extends StatelessWidget {
  const RecordsTable({
    Key? key,
  }) : super(key: key);

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
        center: Offset(0, 55.h),
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
                    padding: REdgeInsets.symmetric(vertical: 35.0),
                    child: Text(
                      'Records',
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
                  _buildRecordsList(),
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppColors.borderRadius,
                      border: Border.all(
                        color: AppColors.gradientTitle2,
                        width: 4,
                      ),
                      // shape: BoxShape.circle,
                    ),
                    child: FloatingActionButton.small(
                      heroTag: null,
                      backgroundColor: AppColors.gradientTitle1,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GameMenu()));
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.textButtonMenu,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildRecordsList() {
    return BlocSelector<RecordsBloc, RecordsState, Set<Record>>(
      selector: (state) => state.records,
      builder: (_, records) {
        return SingleChildScrollView(
          child: SeparatedColumn(
            separator: SizedBox(height: 4.h),
            children: [
              for (var i = 0; i < records.length; i++)
                _RecordListItem(place: i + 1, record: records.elementAt(i)),
            ],
          ),
        );
      },
    );
  }
}

class _RecordListItem extends StatelessWidget {
  const _RecordListItem({
    Key? key,
    required this.place,
    required this.record,
  }) : super(key: key);

  final int place;
  final Record record;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.05,
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
          borderRadius: BorderRadius.circular(65.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildPlaceText(),
                SizedBox(width: 12.w),
                _buildPlayerName(),
              ],
            ),
            _buildPlayerScore(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceText() {
    return Text(
      '$place.',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: AppColors.textButtonMenu,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerName() {
    return Text(
      'Player',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: AppColors.textButtonMenu,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerScore() {
    return Text(
      '${record.score}',
      style: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 5.0,
        fontWeight: FontWeight.w800,
        color: AppColors.textButtonMenu,
      ),
      textAlign: TextAlign.center,
    );
  }
}
 