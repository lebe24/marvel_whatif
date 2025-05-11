import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_what_if/model/magazine.dart';
import 'package:marvel_what_if/widget/cover_image.dart';
import 'package:marvel_what_if/widget/draggable_slider.dart';
import 'package:marvel_what_if/widget/thewatcher.dart';

// import 'package:whatif/Widget/swiper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  late final AnimationController outAnimationController;
  late int currentIndex = 0;
  final List<Magazine> magazines = Magazine.fakeMagazinesValues;

  @override
  void initState() {
    super.initState();
    outAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1,
    );
  }

  @override
  void dispose() {
    outAnimationController.dispose();
    super.dispose();
  }

  Future<void> openMagazineDetail(
    BuildContext context,
    int index,
  ) async {
    outAnimationController.reverse();
    setState(() => currentIndex = index);
    await Future.delayed(const Duration(seconds: 2));
    // DetailScreen.push(
    //   context,
    //   magazines: magazines,
    //   index: currentIndex,
    // );c
    context.push(
      '/episodeList',
      extra: {
         "magazines": magazines,
         "index": currentIndex,
      },
    );
    outAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return   Stack(
          children:  [
            const TheWatcher(),
            Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Center(
                child:Hero(
                  tag: magazines[currentIndex],
                  child: InfiniteDraggableSlider(
                    index: 0,
                    itemCount: magazines.length,
                    onTapItem: (index) => openMagazineDetail(context, index),
                    shrinkAnimation: outAnimationController,
                    itemBuilder: (_, int index) =>
                         MagazineCoverImage(
                          magazine: magazines[index],
                          height: 250),
                  ),
                ),
              ),
            )],
        );
  }
}
