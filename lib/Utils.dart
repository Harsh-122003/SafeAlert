import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{

  static void showSnackbar({required BuildContext context,required String msg}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  static void navigateWithSlideTransitionWithPushReplacement({
    required BuildContext context,
    required Widget screen,
    required Offset begin,
    required Offset end,
  }) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500), // Adjust duration as needed
      ),
    );
  }

  static void navigateWithSlideTransitionWithPush({
    required BuildContext context,
    required Widget screen,
    required Offset begin,
    required Offset end,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500), // Adjust duration as needed
      ),
    );
  }

}