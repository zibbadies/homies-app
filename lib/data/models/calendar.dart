class DueDay {
  const DueDay({required this.date, required this.total, required this.open});

  final DateTime date;
  final int total;
  final int open;

  factory DueDay.fromJson(Map<String, dynamic> json) => DueDay(
        date: DateTime.parse(json['date'] as String), // "2026-12-07" -> mezzanotte
        total: json['total'] as int,
        open: json['open'] as int,
      );
}

