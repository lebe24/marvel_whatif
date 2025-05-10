import 'package:flutter/material.dart';
import 'package:whatif/core/config/constant/constant.dart';

class BackgroundCover extends StatelessWidget {
  const BackgroundCover({super.key,required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration:const BoxDecoration(
        image: DecorationImage(
      fit: BoxFit.cover, image: WhatIf.appBackground),),
      child: child,
    );
  }
}