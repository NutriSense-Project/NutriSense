import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/daily_entry.dart';
import '../../../data/repositories/daily_repository.dart';
import '../utils/scoring_service.dart';

final dailyRepositoryProvider = Provider<DailyRepository>((ref) => DailyRepository());

final currentDailyEntryProvider = NotifierProviderFamily<DailyEntryNotifier, DailyEntry, DateTime>(
  () => DailyEntryNotifier(),
);

class DailyEntryNotifier extends FamilyNotifier<DailyEntry, DateTime> {
  final DailyRepository _repository = DailyRepository();

  @override
  DailyEntry build(DateTime dateParam) {
    _loadEntry(dateParam);
    return _createEmptyEntry(dateParam);
  }

  DailyEntry _createEmptyEntry(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return DailyEntry(
      id: normalized.toIso8601String().split('T').first,
      date: normalized,
      servings: {},
      score: 45,                    // Force base score
    );
  }

  Future<void> _loadEntry(DateTime date) async {
    try {
      final loaded = await _repository.getEntryForDate(date);
      if (loaded != null) {
        state = loaded;
        print("✅ LOADED saved entry | Score: ${loaded.score}");
      } else {
        state = _createEmptyEntry(date);
        print("ℹ️ Fresh day → Score reset to 45");
      }
    } catch (e) {
      print("❌ Load error: $e");
      state = _createEmptyEntry(date);
    }
  }

  void updateServing(String groupId, int servingsCount) {
    final newServings = Map<String, int>.from(state.servings);

    if (servingsCount <= 0) {
      newServings.remove(groupId);
    } else {
      newServings[groupId] = servingsCount;
    }

    final newScore = ScoringService.calculateScore(newServings);

    state = state.copyWith(
      servings: newServings,
      score: newScore,
    );
  }

  Future<void> save() async {
    try {
      final entryToSave = DailyEntry(
        id: state.id,
        date: state.date,
        servings: Map<String, int>.from(state.servings), // Deep copy
        score: state.score,
      );
      
      await _repository.saveEntry(entryToSave);
      print("💾 SAVED → Date: ${state.date.toIso8601String().split('T').first} | Items: ${state.servings.length} | Score: ${state.score}");
    } catch (e) {
      print("❌ Save error: $e");
    }
  }
}