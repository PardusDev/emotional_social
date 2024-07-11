import '../models/Emotion.dart';

String getEmotionAsset(int emotion) {
  switch (emotion) {
    case 1:
      return 'assets/images/emojis/happy.png';
    case 2:
      return 'assets/images/emojis/shocked.png';
    case 3:
      return 'assets/images/emojis/pensive.png';
    case 4:
      return 'assets/images/emojis/angry.png';
    default:
      return 'assets/images/happy.png';
  }
}