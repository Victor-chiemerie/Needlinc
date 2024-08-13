String filterSpecialChars(String text) {
  /// Filters special characters from a string, replacing them with spaces.
  final RegExp pattern = RegExp(r'[^\w\s]'); // Matches non-alphanumeric characters and whitespace
  return text.replaceAll(pattern, ' ').trim();
}

String filterSpecialCharsNoSpaces(String text) {
  /// Filters special characters from a string, removing them completely.
  final RegExp pattern = RegExp(r'[^\w]'); // Matches non-alphanumeric characters
  return String.fromCharCodes(text.codeUnits.where((codeUnit) => pattern.hasMatch(String.fromCharCode(codeUnit)) == false));
}