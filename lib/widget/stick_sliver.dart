import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marvel_what_if/widget/custom_tween.dart';

class StickySliverAppBar extends StatefulWidget {
  const StickySliverAppBar({
    required this.sizePercent,
    required this.indexNotifier,
    super.key,
  });

  final double sizePercent;
  final ValueNotifier<int> indexNotifier;

  @override
  State<StickySliverAppBar> createState() => _StickySliverAppBarState();
}

class _StickySliverAppBarState extends State<StickySliverAppBar> {
  late final PageController controller;

  void indexListener() {
    controller.animateToPage(
      widget.indexNotifier.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    controller = PageController(initialPage: widget.indexNotifier.value);
    widget.indexNotifier.addListener(indexListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    widget.indexNotifier.removeListener(indexListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
    toolbarHeight: lerpDouble(150 * (screenHeight / 812), 50 * (screenHeight / 812), widget.sizePercent)!,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 10 * widget.sizePercent,
      shadowColor: Colors.white60,
      pinned: true,
      actions: [
        Expanded(
          child: CustomTweenAnimation(
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 20 * (screenHeight / 812)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: FittedBox(
                        alignment: Alignment(-1 * (1 - widget.sizePercent), 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'SEASON',
                            style: TextStyle(
                              fontSize: 40 * (screenHeight / 812),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,)
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: FittedBox(
                        alignment: Alignment(-1 * (1 - widget.sizePercent), 0),
                        child: Stack(
                          children: [
                            Text(
                              '${index < 9 ? '0' : ''}${index + 1}',
                              style:
                                  const TextStyle(
                                    fontWeight: FontWeight.bold),
                            ),
                            Positioned.fill(
                              child: Transform.rotate(
                                angle: -pi * .1,
                                child: const Divider(
                                  color: Colors.white10,
                                  thickness: .3,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
