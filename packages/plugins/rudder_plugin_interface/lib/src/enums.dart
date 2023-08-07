enum DataResidencyServer {
  US(residencyServer: "US"),
  EU(residencyServer: "EU");

  const DataResidencyServer({required this.residencyServer});

  final String residencyServer;
  String get getValue => residencyServer;
}
