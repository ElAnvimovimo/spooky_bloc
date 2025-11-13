import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spooky_bloc/events/player_events.dart';
import 'package:spooky_bloc/states/player_states.dart';

import '../blocs/player_bloc.dart';
import '../models/audio_item.dart';

class Swiper extends StatefulWidget {
  final PageController pageController;
  final List<AudioItem> audioList;
  final PlayerBloc bloc;
  final Color color;

  const Swiper({
    Key? key,
    required this.pageController,
    required this.audioList,
    required this.color,
    required this.bloc,
  }) : super(key: key);

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .3,
              child: PageView.builder(
                controller: widget.pageController,
                onPageChanged: (indice){
                  final PlayingState actual  = widget.bloc.state as PlayingState;
                  debugPrint("$actual");
                  if (actual is PlayingState  && indice != actual.currentIndex ){
                    widget.bloc.add(LoadingEvent(index: indice));
                  }
                },
                itemCount: widget.audioList.length,
                itemBuilder: (contex, index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      widget.audioList[index].imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            //Divider(),
            //Spacer()
            SizedBox(height: 15),
            SmoothPageIndicator(
              controller: widget.pageController,
              count: widget.audioList.length,
              axisDirection: Axis.horizontal,
              effect: SlideEffect(
                spacing: 8.0,
                radius: 4.0,
                dotWidth: 24.0,
                dotHeight: 16.0,
                paintStyle: PaintingStyle.stroke,
                strokeWidth: 1.5,
                dotColor: Colors.grey,
                activeDotColor: widget.color,
              ),
            ),
          ],
        );
      },
    );
  }
}
