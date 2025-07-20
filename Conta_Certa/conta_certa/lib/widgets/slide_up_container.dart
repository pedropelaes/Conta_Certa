import 'package:flutter/material.dart';

class SlideUpContainer extends StatefulWidget{
  final Widget child;
  final Duration animationDuration;
  final Curve animationCurve;

  const SlideUpContainer({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  State<SlideUpContainer> createState() => _SlideUpContainerState();
}

class _SlideUpContainerState extends State<SlideUpContainer> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: widget.animationCurve)
    );
    
    _animationController.forward();
  }

  @override void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}