// import 'package:flutter/material.dart';

// class AdminProtectRoute extends StatelessWidget {
//   final Widget child; 
//   final bool isAdmin;

//   const AdminProtectRoute({Key? key, required this.child, required this.isAdmin}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (isAdmin) {
//       return child; 
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushNamed(context, "/signin");
//       });
//       return Container();
//     }
//   }
// }
