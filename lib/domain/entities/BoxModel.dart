enum Boxes {
  XS(volume: 1836, dimensions: [17.0, 12.0, 9.0]),
  S(volume: 8740, dimensions: [23.0, 19.0, 10.0]),
  M(volume: 12375, dimensions: [33.0, 25.0, 15.0]);

  final double volume;
  final List<double> dimensions;
  const Boxes({
    required this.volume,
    required this.dimensions,
  });
}