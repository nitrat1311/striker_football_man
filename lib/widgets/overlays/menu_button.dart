// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class MenuButton extends StatelessWidget {
//   final bool isFour;
//   final String text;
//   final Color color1;
//   final Color color2;
//   final Color color3;
//   final Color color4;
//   const MenuButton({
//     Key? key,
//     required this.text,
//     required this.color1,
//     required this.color2,
//     required this.color3,
//     this.isFour = false,
//     this.color4 = Colors.transparent,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       margin: REdgeInsets.symmetric(vertical: 28),
//       decoration: BoxDecoration(
//           border: Border.all(color: const Color.fromRGBO(0, 255, 194, 1)),
//           boxShadow: [
//             BoxShadow(
//               blurStyle: BlurStyle.solid,
//               offset: const Offset(0, 13.0),
//               blurRadius: 9,
//               color: const Color.fromRGBO(0, 0, 0, 0).withOpacity(0.5),
//             ),
//           ],
//           gradient: LinearGradient(
//             colors: isFour
//                 ? [color4, color3, color2, color1]
//                 : [color3, color2, color1],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: const BorderRadius.all(Radius.circular(18))),
//       width: MediaQuery.of(context).size.width / 1.35,
//       height: MediaQuery.of(context).size.height / 8,
//       child: Padding(
//           padding: REdgeInsets.fromLTRB(0, 0, 0, 5),
//           child: Text(
//             text,
//             style: TextStyle(color: Colors.white, fontSize: 58.sp),
//           )),
//     );
//   }
// }
