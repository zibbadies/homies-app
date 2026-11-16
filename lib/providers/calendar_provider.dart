import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/providers/lists_provider.dart';
import '../utils/dates.dart';
import 'package:homies/data/models/calendar.dart';

class CalendarState {
  const CalendarState({required this.month, required this.selected});

  final DateTime month; // DateTime() con il mese, il giorno è il primo del mese
  final DateTime selected; // giorno del mese selezionato
}

class CalendarNotifier extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final today = dateOnly(DateTime.now());
    return CalendarState(month: firstOfMonth(today), selected: today);
  }

  void select(DateTime day) {
    final d = dateOnly(day);
    state = CalendarState(month: firstOfMonth(d), selected: d);
  }

  void changeMonth(int delta) {
    final month = DateTime(state.month.year, state.month.month + delta);
    final today = dateOnly(DateTime.now());
    state = CalendarState(
      month: month,
      // Se si torna al mese corrente seleziona il giorno corrente, altrimenti mette il primo del mese
      selected: firstOfMonth(today) == month ? today : month,
    );
  }
}

final calendarProvider =
    NotifierProvider<CalendarNotifier, CalendarState>(CalendarNotifier.new);

final dueDaysProvider = FutureProvider.autoDispose
    .family<Map<DateTime, DueDay>, DateTime>((ref, month) async {
  final grid = monthGridDays(month);
  final last = grid.last;

  final days = await ref.read(listsRepositoryProvider).getDueDays(
    from: grid.first,
    to: DateTime(last.year, last.month, last.day + 1), // `to` is EXCLUSIVE
  );
  return {for (final d in days) d.date: d};
});
