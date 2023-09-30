import 'dart:math';

class GenerateRandom {
  static double getRandomPriceDouble(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }

  static List<double> getRandomListDouble(
      double min, double max, int itemCount) {
    List<double> random = [];

    for (int i = 0; i < itemCount; ++i) {
      random.add(getRandomPriceDouble(min, max));
    }
    return random;
  }

  static List<int> getRandomListInt(double min, double max, int itemCount) {
    List<int> random = [];

    for (int i = 0; i < itemCount; ++i) {
      random.add(getRandomPriceDouble(min, max).toInt());
    }
    return random;
  }
}
