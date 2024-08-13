/**
 * Adds comma to a value after every three characters
 * 
 * Args:
 *  - input: The string in whuch the comma is to be added
 * 
 * returns:
 * - String: The string with added commas
 */


String addCommas(String input) {
  // Reverse the input string to process from the end
  String reversedInput = input.split('').reversed.join('');
  
  // Add commas every three characters
  String withCommasReversed = reversedInput.replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)},");
  
  // Reverse the string back to its original order and remove any trailing comma
  String result = withCommasReversed.split('').reversed.join('');
  if (result.startsWith(',')) {
    result = result.substring(1);
  }
  
  return result;
}