class RestorePreview {
  const RestorePreview({
    required this.version,
    required this.exportedAt,
    required this.profileName,
    required this.habitCount,
    required this.logCount,
  });

  final String version;

  final DateTime exportedAt;

  final String profileName;

  final int habitCount;

  final int logCount;
}