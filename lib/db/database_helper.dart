import '../model/logg.dart';

abstract class DatabaseHelper {
  Future<void> insert(String event);
  Future<List<Logg>> readAllLogs();
  void clearAll();
  Future<DateTime?> lastMedicineTaken();
  Future<bool> lastStatus();
}

enum Mode { Local, Supabase }
