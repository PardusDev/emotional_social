import 'package:equatable/equatable.dart';

import '../../models/Emotion.dart';

import 'package:equatable/equatable.dart';

class EmotionState extends Equatable {
  final int selectedEmotion;

  const EmotionState(this.selectedEmotion);

  @override
  List<Object> get props => [selectedEmotion];
}
