double correctLatLng(double coordinate) {
  if (coordinate < -180.toDouble()) {
    return coordinate += 360.toDouble();
  }
  if (coordinate > 180.toDouble()) {
    return coordinate -= 360.toDouble();
  }
  return coordinate;
}
