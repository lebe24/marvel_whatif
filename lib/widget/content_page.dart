import 'package:flutter/material.dart';
import 'package:whatif/model/magazine.dart';
import 'package:whatif/services/services.dart';
import 'package:whatif/widget/custom_tween.dart';
import 'package:whatif/widget/movie_details_card.dart';

class ContentMagazinesPageView extends StatefulWidget {
  const ContentMagazinesPageView({
    required this.indexNotifier,
    required this.magazines,
    super.key, 
  });

  final ValueNotifier<int> indexNotifier;
  final List<Magazine> magazines;

  @override
  State<ContentMagazinesPageView> createState() =>
      _ContentMagazinesPageViewState();
}

class _ContentMagazinesPageViewState extends State<ContentMagazinesPageView> {
  late final PageController controller;
  final WhatIfServices whatIfServices = WhatIfServices();
  Size? sizeWidget;
  late Future<dynamic> contentFuture;

  @override
  void initState() {
    super.initState();
    contentFuture = getContent();
    controller = PageController(initialPage: widget.indexNotifier.value);
    widget.indexNotifier.addListener(indexListener);
  }

  Future<dynamic> getContent() async {
    return await whatIfServices.fetchWhatIfTvShow((widget.indexNotifier.value + 1).toString());
  }

  void indexListener() {
    controller.animateToPage(
      widget.indexNotifier.value + 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    widget.indexNotifier.removeListener(indexListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ContentMagazinesPageView: ${widget.indexNotifier.value}');

    return FutureBuilder<dynamic>(
      future: contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data;

        return CustomTweenAnimation(
          child: SizedBox(
            height: sizeWidget?.height ?? MediaQuery.of(context).size.height,
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.magazines.length,
              itemBuilder: (_, index) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizeNotifierWidget(
                    onSizeChange: (value) => setState(() => sizeWidget = value),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 28),
                        for (int x = 0; x < data["episodes"].length; x++) ...[
                          const SizedBox(height: 12),
                          MovieCardDetails(
                            movieData: data["episodes"][x],
                            imagePath: "https://media.themoviedb.org/t/p/w454_and_h254_bestv2/${data["episodes"][x]["still_path"]}",
                            movieTitle: data["episodes"][x]["name"],
                          ),
                          const SizedBox(height: 18),
                          // Text(
                          //   data["episodes"][x]["name"],
                          //   style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: 2),
                          // ),
                          // const SizedBox(height: 12),
                          // Image.network(
                          //   "https://media.themoviedb.org/t/p/w454_and_h254_bestv2/${data["episodes"][x]["still_path"]}",   
                          //   height: 220,
                          //   fit: BoxFit.cover,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 20),
                          //   child: Text(
                          //     data["episodes"][x]["overview"],
                          //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1),
                          //   ),
                          //                           ),
                          // const SizedBox(height: 28),
                    
                          
                          
                          // const SizedBox(height: 28),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class SizeNotifierWidget extends StatefulWidget {
  /// {@macro [SizeNotifierWidget]}
  const SizeNotifierWidget({
    required this.child,
    required this.onSizeChange,
    super.key,
  });

  /// Child of the widget
  final Widget child;

  /// When change size
  final ValueChanged<Size> onSizeChange;

  @override
  State<SizeNotifierWidget> createState() => _SizeNotifierWidgetState();
}

class _SizeNotifierWidgetState extends State<SizeNotifierWidget> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: SizedBox(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size!);
    }
  }
}
