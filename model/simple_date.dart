class SimpleDate {
  final int year;
  final int month;
  final int day;

  SimpleDate(this.year, this.month, this.day);

  SimpleDate.fromDateTime(DateTime dateTime)
    : year = dateTime.year,
      month = dateTime.month,
      day = dateTime.day;

  @override
  String toString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
