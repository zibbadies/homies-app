DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime firstOfMonth(DateTime d) => DateTime(d.year, d.month);

String toApiDay(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

List<DateTime> monthGridDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month+1, 0);

    final leading = first.weekday - DateTime.monday;
    final trailing = DateTime.sunday - last.weekday;
    final count = leading + last.day + trailing;

    return List.generate(
        count,
        (i) => DateTime(first.year, first.month, 1 - leading + i),
    );
}
