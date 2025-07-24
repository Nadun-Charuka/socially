enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

extension MoodExtension on Mood {
  String get name {
    switch (this) {
      case Mood.happy:
        return "Happy";
      case Mood.sad:
        return 'sad';
      case Mood.angry:
        return 'angry';
      case Mood.excited:
        return 'excited';
      case Mood.bored:
        return 'bored';
    }
  }

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.sad:
        return '😢';
      case Mood.angry:
        return '😡';
      case Mood.excited:
        return '🤩';
      case Mood.bored:
        return '😴';
    }
  }

  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name == moodString,
      orElse: () => Mood.happy,
    );
  }
}
