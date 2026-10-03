# R8 keep rules for release builds.
#
# AGP 9 runs R8 in full mode: a "-keep class X" rule without members no
# longer keeps X's constructors. The Google Mobile Ads SDK pulls in old
# WorkManager (2.7) and Room (2.2) releases whose bundled rules rely on
# the old behaviour, so R8 removed WorkDatabase_Impl's constructor and
# every release build crashed at launch (WorkManager starts from
# androidx.startup even when ads are off):
#
#   RuntimeException: Failed to create an instance of
#   androidx.work.impl.WorkDatabase
#
# Keep the constructors these libraries call by reflection.

# Room creates <Database>_Impl with its no-argument constructor.
-keep class * extends androidx.room.RoomDatabase {
    <init>();
}

# WorkManager creates input mergers and workers by class name.
-keep class * extends androidx.work.InputMerger {
    <init>();
}
-keep class * extends androidx.work.ListenableWorker {
    <init>(android.content.Context, androidx.work.WorkerParameters);
}
