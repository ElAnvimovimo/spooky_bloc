import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/audio_item.dart';

class Swiper extends StatelessWidget {
  final PageController pageController;
  final List<AudioItem> audioList;
  final Color color;
  final Function(int) onPageChanged;

  const Swiper({
    Key? key,
    required this.pageController,
    required this.audioList,
    required this.color,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (audioList.isEmpty) return const SizedBox();

    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: audioList.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    audioList[index].imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        SmoothPageIndicator(
          controller: pageController,
          count: audioList.length,
          effect: SwapEffect(
            activeDotColor: color,
            dotColor: Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 20,
            type: SwapType.yRotation,
          ),
          onDotClicked: (index) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}