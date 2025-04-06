import 'package:flutter/material.dart';

class AnimatedCircularProgress extends StatefulWidget {
  final double progress; // 传入的进度值 (0.0 - 1.0)
  final Duration duration; // 动画时长
  final double strokeWidth; // 进度条宽度
  final Color? backgroundColor; // 背景颜色
  final Color progressColor; // 进度颜色

  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.duration = const Duration(milliseconds: 500),
    this.strokeWidth = 4.0,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation =
        Tween<double>(begin: 0.0, end: widget.progress).animate(_controller);
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 progress 变化了，平滑过渡
    if (oldWidget.progress != widget.progress) {
      _animateTo(widget.progress);
    }
  }

  void _animateTo(double targetProgress) {
    _animation = Tween<double>(begin: _animation.value, end: targetProgress)
        .animate(_controller);
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: _animation.value, // 平滑过渡的进度值
          strokeWidth: widget.strokeWidth,
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation(widget.progressColor),
        );
      },
    );
  }
}
