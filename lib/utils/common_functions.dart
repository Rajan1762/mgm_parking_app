String reportDateFormat(DateTime date)
{
  return '${date.year}${_addLeadingZero(date.month)}${_addLeadingZero(date.day)}';
}

String formatDate(DateTime date) {
  return '${date.year}-${_addLeadingZero(date.month)}-${_addLeadingZero(date.day)}';
}

String _addLeadingZero(int number) {
  return number.toString().padLeft(2, '0');
}

String formatTime(DateTime dateTime)
{
  return '${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
}
