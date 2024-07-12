import 'package:bloc/bloc.dart';

import '../../models/Emotion.dart';
import 'emotion_event.dart';
import 'emotion_state.dart';

class EmotionBloc extends Bloc<EmotionEvent, EmotionState> {
  EmotionBloc() : super(const EmotionState(Emotion.happy));

  Stream<EmotionState> mapEventToState(EmotionEvent event) async* {
    if (event is SelectEmotion) {
      yield EmotionState(event.emotion);
    }
  }
}