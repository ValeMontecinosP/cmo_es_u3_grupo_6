import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/widgets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [
        AuthBackgorundC1(),
        SafeArea(
            child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 10),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 100,
          ),
        )),
        child,
      ]),
    );
  }
}
