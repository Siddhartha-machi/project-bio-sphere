class DTUtility {
  /// Returns true if [firstDate] occurs before [secondDate].
  static bool isBefore(DateTime firstDate, DateTime secondDate) =>
      firstDate.isBefore(secondDate);

  /// Returns true if [firstDate] occurs after [secondDate].
  static bool isAfter(DateTime firstDate, DateTime secondDate) =>
      firstDate.isAfter(secondDate);

  /// Returns true if [dateToCheck] is today's date.
  static bool isToday(DateTime dateToCheck) {
    final today = DateTime.now();

    return isSameDay(dateToCheck, today);
  }

  /// Returns true if [dateToCheck] is yesterday.
  static bool isYesterday(DateTime dateToCheck) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return isSameDay(dateToCheck, yesterday);
  }

  /// Returns true if [dateToCheck] is tomorrow.
  static bool isTomorrow(DateTime dateToCheck) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    return isSameDay(dateToCheck, tomorrow);
  }

  /// Returns true if [firstDate] and [secondDate] fall on the same calendar day.
  static bool isSameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }

  /// Returns how many full days have passed since [startDate] until now.
  static int daysPassed(DateTime startDate, {DateTime? endDate}) {
    final start = stripTime(startDate);
    final end = stripTime(endDate ?? DateTime.now());

    return end.difference(start).inDays;
  }

  /// Returns how many full days are remaining from now until [endDate].
  static int daysRemaining(DateTime endDate, {DateTime? startDate}) {
    final end = stripTime(endDate);
    final start = stripTime(startDate ?? DateTime.now());

    return end.difference(start).inDays;
  }

  /// Returns true if [targetDate] lies between [startDate] and [endDate] (inclusive).
  static bool isBetween(
    DateTime targetDate,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (targetDate.isAtSameMomentAs(startDate) ||
            targetDate.isAfter(startDate)) &&
        (targetDate.isAtSameMomentAs(endDate) || targetDate.isBefore(endDate));
  }

  /// Returns only the date part of [dateTime] (time set to midnight).
  static DateTime stripTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
