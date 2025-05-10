import 'package:flutter/material.dart';
import 'package:marvel_what_if/core/config/constant/constant.dart';

class TheWatcher extends StatelessWidget {
  const TheWatcher({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Stack(
      children: [
        Positioned(child: Image(image: WhatIf.appLogo, fit: BoxFit.cover)),
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(top:108.0),
            child: Image(image: WhatIf.theWatcher, fit: BoxFit.cover),
          ),
        ),
      ]
    );
  }
}

