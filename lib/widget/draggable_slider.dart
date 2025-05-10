import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
// import 'package:ui_common/ui_common.dart';

double sw(BuildContext context) => MediaQuery.of(context).size.width;


class InfiniteDraggableSlider extends StatefulWidget {
  const InfiniteDraggableSlider({
    required this.itemBuilder,
    super.key,
    this.onTapItem,
    this.shrinkAnimation = const AlwaysStoppedAnimation(1),
    this.index = 0,
    this.itemCount,
  });

  /// [Animation] that shrinks the slider elements
  final Animation<double> shrinkAnimation;

  /// [ValueChanged] that is executed when tapping on the element and returns
  /// the index that it has
  final ValueChanged<int>? onTapItem;

  /// Initial index of the first element displayed in the slider
  final int index;

  // Removed from here as context is not accessible in the widget class


  /// Maximum number of elements inside the slider
  final int? itemCount;

  /// Widget Function that builds the elements shown in the slider based on its
  /// index and its context
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<InfiniteDraggableSlider> createState() =>
      _InfiniteDraggableSliderState();
}

class _InfiniteDraggableSliderState extends State<InfiniteDraggableSlider>
    with TickerProviderStateMixin {
  
  late final AnimationController controller;
  late int index;
  static const inclineLeft = -math.pi * .1;
  static const inclineRight = math.pi * .1;
  SlideDirection direction = SlideDirection.left;

  void animationListener() {
    if (controller.isCompleted) {
      setState(() {
        if (widget.itemCount == ++index) {
          index = 0;
        }
      });
      controller.reset();
    }
  }

  /// Called when the user slides out and assigns the value of the direction
  /// in which the user slid the element
  void onSlideOut(SlideDirection direction) {
    this.direction = direction;
    controller.forward();
  }

  /// Gets the scale of the item according to its position in the [Stack]
  double getScale(int stackIndex) =>
      {
        0: ui.lerpDouble(.6, .9, controller.value)!,
        1: ui.lerpDouble(.9, .95, controller.value)!,
        2: ui.lerpDouble(.95, 1, controller.value)!,
      }[stackIndex] ??
      1.0;

  /// Gets the [Offset] on the item according to its position in the [Stack]
  Offset getOffset(int stackIndex) =>
        {
          0: Offset(ui.lerpDouble(0, -70, controller.value)!, 30),
          1: Offset(ui.lerpDouble(-70, 70, controller.value)!, 30),
          2: const Offset(70, 30) * (1 - controller.value),
        }[stackIndex] ??
        Offset(sw(context) * controller.value * (direction.isLeft ? -1 : 1), 0);

  /// Gets the incline angle of the item according to its position in the [Stack]
  double getAngle(int stackIndex) =>
      {
        0: ui.lerpDouble(0, inclineLeft, controller.value)!,
        1: ui.lerpDouble(inclineLeft, inclineRight, controller.value)!,
        2: ui.lerpDouble(inclineRight, 0, controller.value)!,
      }[stackIndex] ??
      math.pi * .1 * controller.value * (direction.isLeft ? -1 : 1);

  @override
  void initState() {
    index = widget.index;
    controller =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(animationListener);

    super.initState();
  }

  @override
  void dispose() {
    controller
      ..removeListener(animationListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final length = widget.itemCount;
        return Stack(
          children: List.generate(
            4,
            (stackIndex) {
              final scale = getScale(stackIndex);
              final offset = getOffset(stackIndex);
              final angle = getAngle(stackIndex);
              final modIndex = length != null
                  ? (index + 3 - stackIndex) % length
                  : (index + 3 - stackIndex);
              return FadeTransition(
                opacity: stackIndex == 0
                    ? controller
                    : stackIndex != 3
                        ? widget.shrinkAnimation
                        : const AlwaysStoppedAnimation(1),
                child: AnimatedBuilder(
                  animation: widget.shrinkAnimation,
                  builder: (_, child) => _CustomTransform(
                    scale: scale,
                    offset: offset * widget.shrinkAnimation.value,
                    angle: angle * widget.shrinkAnimation.value,
                    child: child!,
                  ),
                  child: DraggableWidget(
                    onPressed: () => widget.onTapItem?.call(modIndex),
                    enableDrag: stackIndex == 3,
                    onSlideOut: onSlideOut,
                    child: widget.itemBuilder(context, modIndex),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Indicates the direction in which the user swiped the card
enum SlideDirection { left, right }

extension SlideDirectoExt on SlideDirection {
  bool get isRight => this == SlideDirection.right;

  bool get isLeft => this == SlideDirection.left;
}


class _CustomTransform extends StatelessWidget {
  const _CustomTransform({
    required this.child,
    this.offset = Offset.zero,
    this.angle = 0.0,
    this.scale = 1.0,
  });

  final Offset offset;
  final double angle;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(offset.dx, offset.dy)
        ..scale(scale),
      child: Transform.rotate(
        angle: angle,
        child: child,
      ),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  /// Widget that can be dragged around the screen
  const DraggableWidget({
    required this.child,
    required this.enableDrag,
    super.key,
    this.onSlideOut,
    this.onPressed,
  });

  /// [ValueChanged] that is called when the user swipe left or right quickly
  final ValueChanged<SlideDirection>? onSlideOut;

  /// [VoidCallback] that is executed when the item is tapped
  final VoidCallback? onPressed;

  /// Allows you to enable or disable being able to drag the widget
  final bool enableDrag;

  /// Widget that is wrapped in order to give it the ability to be draggable
  final Widget child;

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget>
    with SingleTickerProviderStateMixin {
  // Animation controller when user releases drag without swiping out
  late final AnimationController restoreController;

  // Global key assigned to the child widget's container to retrieve its
  // position on the screen and its size
  final GlobalKey _widgetKey = GlobalKey();

  // Value of the initial position of the cursor when the user begins dragging
  Offset startOffset = Offset.zero;

  // Value of the cursor position while the user is dragging
  Offset panOffset = Offset.zero;

  // Size of the child widget
  Size size = Size.zero;

  // Lean angle when dragging
  double angle = 0;

  // Value that detects if the user performed a slide out
  bool itWasMadeSlide = false;

  // Width that must be outside the screen for the slide out to take place
  double get outSizeLimit => size.width * .65;

  // Use the global key of the child widget's container to return the position
  // the widget is in
  Offset get currentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  // Gets the value of the tilt angle based on the position in which the widget
  // is and its size
  double get currentAngle {
    return currentPosition.dx < 0
        ? (math.pi * .2) * currentPosition.dx / size.width
        : currentPosition.dx + size.width > sw(context)
            ? (math.pi * .2) *
                (currentPosition.dx + size.width - sw(context)) /
                size.width
            : 0;
  }

  // Assigns the initial touch point when dragging the widget
  void onPanStart(DragStartDetails details) {
    if (restoreController.isAnimating) return;
    setState(() => startOffset = details.globalPosition);
  }

  // Updates the position and tilt angle based on the global position of
  // the touch point and the initial touch point
  void onPanUpdate(DragUpdateDetails details) {
    if (restoreController.isAnimating) return;
    setState(() {
      panOffset = details.globalPosition - startOffset;
      angle = currentAngle;
    });
  }

  // Obtains the speed when the drag is released and the position of the widget
  // and based on these values the slide out function is executed
  void onPanEnd(DragEndDetails details) {
    if (restoreController.isAnimating) return;
    final velocityX = details.velocity.pixelsPerSecond.dx;
    final positionX = currentPosition.dx;
    if (velocityX < -1000 || positionX < -outSizeLimit) {
      itWasMadeSlide = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.left);
    }
    if (velocityX > 1000 || positionX > (sw(context) - outSizeLimit)) {
      itWasMadeSlide = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.right);
    }
    restoreController.forward();
  }

  void restoreControllerListener() {
    if (restoreController.isCompleted) {
      restoreController.reset();
      panOffset = Offset.zero;
      itWasMadeSlide = false;
      angle = 0;
      setState(() {});
    }
  }

  void getChildSize() {
    size =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  @override
  void initState() {
    restoreController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    )..addListener(restoreControllerListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getChildSize();
    });
    super.initState();
  }

  @override
  void dispose() {
    restoreController
      ..removeListener(restoreControllerListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(key: _widgetKey, child: widget.child);
    if (!widget.enableDrag) return child;
    return GestureDetector(
      onTap: widget.onPressed,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedBuilder(
        animation: restoreController,
        builder: (context, child) {
          final value = 1 - restoreController.value;
          return Transform.translate(
            offset: panOffset * (itWasMadeSlide ? 1 : value),
            child: Transform.rotate(
              angle: angle * (itWasMadeSlide ? 1 : value),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}
