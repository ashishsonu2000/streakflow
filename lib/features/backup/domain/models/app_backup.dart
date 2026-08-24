class AppBackup {
  const AppBackup({
    required this.version,
    required this.exportedAt,
    required this.profile,
    required this.habits,
    required this.logs,
  });

  final String version;

  final DateTime exportedAt;

  final Map<String, dynamic> profile;

  final List<Map<String, dynamic>> habits;

  final List<Map<String, dynamic>> logs;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportedAt': exportedAt.toIso8601String(),
      'profile': profile,
      'habits': habits,
      'logs': logs,
    };
  }
}