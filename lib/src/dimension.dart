class Dimension {
  double height;
  double width;

  Dimension({required this.height, required this.width}) {
    print("height::$width");
  }

  double getWidth(double w) {
    double screenOccupiedWidth = width / w;
    return width / screenOccupiedWidth;
  }

  double getHeight(double w) {
    double screenOccupiedHeight = height / w;
    return height / screenOccupiedHeight;
  }
}
