import 'package:isar_community/isar.dart';

part 'database_metadata.g.dart';

@collection
class DatabaseMetadata {
  Id id = 1;

  int schemaVersion = 1;
}
