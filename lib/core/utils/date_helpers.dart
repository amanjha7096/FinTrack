  class DateHelpers {
  DateHelpers._();

  static DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

  static DateTime endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

  static List<DateTime> daysInMonth(DateTime date) {
    final start = startOfMonth(date);
    final totalDays = endOfMonth(date).day;
    return List<DateTime>.generate(
      totalDays,
      (index) => DateTime(start.year, start.month, start.day + index),
    );
  }
}