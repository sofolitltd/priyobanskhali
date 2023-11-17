import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;

  const ImageSlider({super.key, required this.imageUrls});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex >= widget.imageUrls.length) {
          _currentIndex = 0;
        }
        _pageController.animateToPage(_currentIndex,
            duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(widget.imageUrls[index]);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.imageUrls.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(5),
                width: _currentIndex == i ? 24 : 10,
                height: _currentIndex == i ? 12 : 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: _currentIndex == i
                      ? const Color(0xff1A6642)
                      : Colors.grey,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

