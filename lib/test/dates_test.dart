import 'package:flutter_test/flutter_test.dart';
import 'package:homies/utils/dates.dart';

void main() {
  test('December 2026 grid is Mon 30 Nov .. Sun 3 Jan', () {
    final days = monthGridDays(DateTime(2026, 12));
    expect(days.length, 35);
    expect(days.first, DateTime(2026, 11, 30));
    expect(days.last, DateTime(2027, 1, 3));
  });

  test('February 2027 starts on Monday and fits in exactly 4 rows', () {
    expect(monthGridDays(DateTime(2027, 2)).length, 28);
  });
}
