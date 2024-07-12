import 'package:flutter/material.dart';

import '../utilities/asset_loader.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  final List<int> emotions = [3,1,2,4];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      emotions.length,
          (index) => AnimationController(
        duration: Duration(seconds: 4 + index * 2),
        vsync: this,
      )..repeat(),
    );

    _animations = List.generate(
      emotions.length,
          (index) => Tween<Offset>(
        begin: Offset(0.0 - index * 0.3, 0),
        end: Offset(1.0 + index * 0.3, 0),
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.linear,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: List.generate(emotions.length, (index) {
                  return AnimatedBuilder(
                    animation: _controllers[index],
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: _animations[index].value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 96),
                          child: Image.asset(
                            getEmotionAsset(emotions[index]),
                            height: 60,
                            width: 60,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}