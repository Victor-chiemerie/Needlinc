/**
 * This function formats string
 * -input : Takes in a String  argument of the string to be formatted
 * -chara: Takes in the number of character expected to be return
*/
String selectCharacters(String input, int char) {
  if (input.length <= char) {
    return input;
  } else {
    return "${input.substring(0, char)}...";
  }
}