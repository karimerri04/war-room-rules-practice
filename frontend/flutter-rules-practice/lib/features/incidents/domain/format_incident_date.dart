String formatIncidentDate(String rawDate) {
  final parsedDate = DateTime.tryParse(rawDate);

  if (parsedDate == null) {
    return rawDate;
  }

  final localDate = parsedDate.toLocal();

  final year = localDate.year.toString().padLeft(4, '0');
  final month = localDate.month.toString().padLeft(2, '0');
  final day = localDate.day.toString().padLeft(2, '0');
  final hour = localDate.hour.toString().padLeft(2, '0');
  final minute = localDate.minute.toString().padLeft(2, '0');

  return '$year-$month-$day $hour:$minute';
}