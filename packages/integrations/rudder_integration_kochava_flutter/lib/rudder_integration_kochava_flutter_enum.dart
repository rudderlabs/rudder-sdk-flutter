enum RudderKochavaLogLevel {
  TRACE("TRACE"),
  DEBUG("DEBUG"),
  INFO("INFO"),
  WARN("WARN"),
  ERROR("ERROR"),
  NONE("NONE");

  const RudderKochavaLogLevel(this.loglevel);

  final String loglevel;

  @override
  String toString() {
    return loglevel;
  }
}
