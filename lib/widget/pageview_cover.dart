import 'package:flutter/material.dart';
import 'package:whatif/model/magazine.dart';
import 'dart:ui' as ui;

import 'package:whatif/widget/cover_image.dart';
import 'package:whatif/widget/draggable_slider.dart';


class PageViewCover extends StatefulWidget {
  const PageViewCover({super.key, required this.sizePercent, required this.initialIndex, required this.magazines});

  final double sizePercent;
  final int initialIndex;
  final List<Magazine> magazines;

  @override
  State<PageViewCover> createState() => _PageViewCoverState();
}

class _PageViewCoverState extends State<PageViewCover> {

  late final PageController pageController;
  late double page;

  void _pageListener() {
    setState(() {
      page = pageController.page ?? 0;
    });
  }

  @override
  void initState() {
    page = widget.initialIndex.toDouble();
    pageController = PageController(initialPage: widget.initialIndex)
      ..addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildCustomHero(_, Animation<double> animation, __, ___, ____) {
    return InfiniteDraggableSlider(
      index: page.floor(),
      itemCount: widget.magazines.length,
      shrinkAnimation: Tween<double>(begin: 1, end: 0).animate(animation),
      itemBuilder: (_, index) => MagazineCoverImage(
        magazine: widget.magazines[index],
      ),
    );
  }



  
  @override
  Widget build(BuildContext context) {
    final magazine = widget.magazines[widget.initialIndex];
    return  PageView(
      clipBehavior: Clip.none,
      controller: pageController,
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              top: -200 * widget.sizePercent,
              bottom: -400 * widget.sizePercent,
                    child: Image.asset(
                      magazine.assetImage,
                      fit: BoxFit.cover,
                    ),
            ),
            ClipRect(
                clipBehavior: Clip.antiAlias,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const ColoredBox(color: Colors.black26),
              ),
            ),
            Positioned.fill(
                top: MediaQuery.of(context).padding.top,
                bottom: - MediaQuery.of(context).size.height * widget.sizePercent,
                child: Center(
                  child: Hero(
                    tag: widget.magazines[widget.initialIndex],
                    flightShuttleBuilder: buildCustomHero,
                    child: MagazineCoverImage(
                      magazine: magazine,
                      height: ui.lerpDouble(MediaQuery.of(context).size.height * .35, MediaQuery.of(context).size.height *.25, widget.sizePercent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}