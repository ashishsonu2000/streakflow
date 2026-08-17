import 'package:isar_community/isar.dart';

part 'profile_collection.g.dart';

@collection
class ProfileCollection {
  Id id = 1;

  late String name;

  late bool notificationsEnabled;

  late bool onboardingCompleted;

  List<String> goals = [];

  late String themeMode;
}