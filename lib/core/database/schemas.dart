import '../../features/habits/data/entities/habit_entity.dart';
import '../../features/habits/data/entities/habit_log_entity.dart';

import 'collections/profile_collection.dart';
import 'entities/database_metadata.dart';

final databaseSchemas = [
  HabitEntitySchema,
  HabitLogEntitySchema,
  DatabaseMetadataSchema,
  ProfileCollectionSchema,
];