import 'package:equatable/equatable.dart';

import '../../models/Emotion.dart';

abstract class EmotionEvent extends Equatable {
  const EmotionEvent();

  @override
  List<Object> get props => [];
}

class SelectEmotion extends EmotionEvent {
  final int emotion;

  const SelectEmotion(this.emotion);

  @override
  List<Object> get props => [emotion];
}