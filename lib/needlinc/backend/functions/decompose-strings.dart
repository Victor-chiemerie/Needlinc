import 'filter-special-characters.dart';

extension ListExtension<T> on List<T> {
  Iterable<List<T>> combination(int k) sync* {
    if (k == 0) {
      yield [];
    } else {
      for (var i = 0; i < length; i++) {
        final subList = sublist(i + 1);
        final subCombinations = subList.combination(k - 1);
        for (var combination in subCombinations) {
          yield [this[i], ...combination];
        }
      }
    }
  }
}

List<String> combineWords(String text1, String text2, String text3) {
  final elements = [
    decomposeString(filterSpecialChars(text1), limit: 5),
    decomposeString(filterSpecialChars(text2), limit: 3),
    decomposeString(filterSpecialChars(text3), limit: 2),
  ].where((element) => element.isNotEmpty).expand((list) => list).toList();
  return combineElements(elements);
}

List<String> combineElements<T>(List<T> elements) {
  final combinedElements = <String>{};
  for (var i = 1; i <= elements.length; i++) {
    final combinations = elements.toList(growable: false).combination(i);
    for (var combination in combinations) {
      combinedElements.add(combination.join(' '));
    }
  }
  return combinedElements.toList();
}

List<String> decomposeString(String text, {int limit = 0}) {
  // Trim leading and trailing whitespaces
  final trimmedText = text.trim();
  // Split the string by spaces
  final words = trimmedText.split(' ');

  if (limit > 0) {
    // Limit the number of words
    return words
        .sublist(0, limit.clamp(0, words.length))
        .where((word) => word.isNotEmpty)
        .toList();
  } else {
    // Use all words
    return words.where((word) => word.isNotEmpty).toList();
  }
}