import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvel_what_if/model/magazine.dart';
import 'package:marvel_what_if/widget/background_cover.dart';
import 'package:marvel_what_if/widget/content_page.dart';
import 'package:marvel_what_if/widget/pageview_cover.dart';
import 'package:marvel_what_if/widget/stick_sliver.dart';
import 'package:ui_common/ui_common.dart';


class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.index, required this.magazines, required this.tag});

  final int index;
  final List<Magazine> magazines;
  final String tag ;

  static void push(
    BuildContext context, {
    required int index,
    required List<Magazine> magazines,
    required String tag,
  }) =>
      Navigator.push<int>(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: DetailScreen(
              index: index,
              magazines: magazines, 
              tag: tag,
            ),
          ),
        ),
      );

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final ScrollController scrollController;
  late ValueNotifier<int> indexNotifier;
  double headerPercent = 0;


  void scrollListener() {
    headerPercent =
        (scrollController.offset / MediaQuery.of(context).size.height * .65).clamp(0, 1);
    if (headerPercent < 1) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    indexNotifier = ValueNotifier(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(scrollListener)
      ..dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    print('index: ${widget.index}');

    return Scaffold(
        body: PopScope(
        
        child: BackgroundCover(
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                slivers: [
                  SliverPersistentHeader(
                    delegate: BuilderPersistentDelegate(
                      minExtent: 0,
                      maxExtent: MediaQuery.of(context).size.height * 0.65,
                      builder: (percent) => Stack(
                        children: [
                          PageViewCover(
                            sizePercent: percent,
                            initialIndex: indexNotifier.value,
                            magazines: widget.magazines,
                          ),
                        ],
                      ),
                    ),
                  ),
                  StickySliverAppBar(
                    sizePercent: headerPercent,
                    indexNotifier: indexNotifier,
                  ),
                  SliverToBoxAdapter(
                    child: ContentMagazinesPageView(
                      indexNotifier: indexNotifier,
                      magazines: widget.magazines,
                      tag: widget.tag,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ViceUIConsts {
  ViceUIConsts._();

  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.3, 1],
      colors: [
    Color(0xff9876cc),
    Color(0xff80c7a9),
  ],
    ),
  );

}