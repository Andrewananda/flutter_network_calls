import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(2)
      ),
      child: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.orange,
          size: 50,
        ),
      ),
    );
  }
}
