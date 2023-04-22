import 'dart:math';

int boyerMooreSearch(List<int> arr, List<int> pattern) {
  final int arrLen = arr.length;
  final int patternLen = pattern.length;

  if (patternLen == 0) {
    return 0;
  }

  final Map<int, int> badChar = {};
  for (int i = 0; i < patternLen; i++) {
    badChar[pattern[i]] = i;
  }

  int shift = 0;
  while (shift <= arrLen - patternLen) {
    int j = patternLen - 1;

    while (j >= 0 && pattern[j] == arr[shift + j]) {
      j--;
    }

    if (j < 0) {
      return shift;
    } else {
      final int charIndex = arr[shift + j];
      final int badCharShift =
          badChar.containsKey(charIndex) ? badChar[charIndex]! : -1;
      shift += max(1, j - badCharShift);
    }
  }

  return -1;
}
