String formatAmount(String amountStr) {
  // Convert the input string to a double
  double amount = double.tryParse(amountStr) ?? 0;

  // Check the value and format accordingly
  if (amount >= 1000000000000) {
    return "${(amount / 1000000000000).toStringAsFixed(2)}T";
  } else if (amount >= 1000000000) {
    return "${(amount / 1000000000).toStringAsFixed(2)}B";
  } else if (amount >= 1000000) {
    return "${(amount / 1000000).toStringAsFixed(2)}M";
  } else if (amount >= 1000) {
    return "${(amount / 1000).toStringAsFixed(2)}K";
  } else {
    return amountStr;
  }
}
