/**
  Calculates the optimal number of columns in a grid layout for Flutter's GridView.builder.

  Args:
      screenWidth (double): The width of the screen in pixels.
      minItemWidth (int, optional): The minimum desired width for each item in the grid. Defaults to 100.
      maxColumns (int, optional): The maximum number of columns allowed in the grid. Defaults to 5.

  Returns:
      int: The calculated number of columns for the grid layout.
*/

int calculateCrossAxisCount(double screenWidth, double margins, minItemWidth) {
  

  // Start with the maximum columns
  int columns = 4;

  double usableWidth = screenWidth - margins;

  // Iteratively reduce columns until the minimum item width is met or max_columns is reached
  while (columns > 1 && usableWidth / columns < minItemWidth) {
    columns--;
  }

  return columns;
}
