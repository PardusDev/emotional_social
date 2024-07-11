class Emotion {
  static const int happy = 1;
  static const int shocked = 2;
  static const int pensive = 3;
  static const int angry = 4;

  static const Map<int, String> emotionMap = {
    happy: 'Happy',
    shocked: 'Shocked',
    pensive: 'Pensive',
    angry: 'Angry',
  };

  static String getEmotionName(int emotion) {
    return emotionMap[emotion] ?? 'Unknown';
  }
}